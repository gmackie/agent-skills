#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  inspect-vinext-cloudflare.sh --repo /path/to/project [--format text|json]

Options:
  --repo PATH           Project repo root. Required.
  --format FORMAT       Output format: text or json. Default: text.
  --help                Show this help.
EOF
}

repo=""
format="text"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="${2:-}"
      shift 2
      ;;
    --format)
      format="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$repo" ]]; then
  echo "--repo is required" >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$repo" ]]; then
  echo "repo not found: $repo" >&2
  exit 1
fi

repo="$(cd "$repo" && pwd)"

has_file() {
  [[ -e "$repo/$1" ]]
}

has_package() {
  local package_name="$1"
  [[ -f "$repo/package.json" ]] || return 1
  jq -e --arg package_name "$package_name" '
    (.dependencies // {})[$package_name] != null or
    (.devDependencies // {})[$package_name] != null
  ' "$repo/package.json" >/dev/null
}

read_script_field() {
  local key="$1"
  if [[ -f "$repo/package.json" ]]; then
    jq -r --arg key "$key" '.scripts[$key] // empty' "$repo/package.json"
  fi
}

find_files_json() {
  local pattern="$1"
  find "$repo" -maxdepth 2 -name "$pattern" -print 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
}

wrangler_files_json="$(
  {
    find "$repo" -maxdepth 1 -name 'wrangler.jsonc' -print 2>/dev/null
    find "$repo" -maxdepth 1 -name 'wrangler.toml' -print 2>/dev/null
  } | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

vite_files_json="$(find_files_json 'vite.config.*')"
env_files_json="$(
  find "$repo" -maxdepth 1 \( -name '.env' -o -name '.env.*' -o -name '.dev.vars' -o -name '.dev.vars.*' \) -print 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
)"

binding_usage_json="$(
  rg -l --hidden --glob '!node_modules' --glob '!\.git' \
    'KVCacheHandler|IMAGES|ASSETS|R2Bucket|KVNamespace|DurableObjectNamespace|cache' \
    "$repo" 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
)"

wrangler_lines_json="$(
  if [[ -f "$repo/wrangler.jsonc" || -f "$repo/wrangler.toml" ]]; then
    rg -n 'assets|images|kv_namespaces|r2_buckets|durable_objects|services' "$repo"/wrangler.* 2>/dev/null \
      | sed "s|$repo/||" \
      | jq -R . \
      | jq -s 'map(select(length > 0))'
  else
    printf '[]'
  fi
)"

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'vinext_dependency\t%s\n' "$(has_package vinext && echo present || echo missing)"
  printf 'wrangler_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "missing" end' <<<"$wrangler_files_json")"
  printf 'vite_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "missing" end' <<<"$vite_files_json")"
  printf 'dev_script\t%s\n' "$(read_script_field dev)"
  printf 'build_script\t%s\n' "$(read_script_field build)"
  printf 'deploy_script\t%s\n' "$(read_script_field deploy)"
  printf 'env_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$env_files_json")"
  printf 'wrangler_markers\t%s\n' "$(jq -r 'if length > 0 then join(" | ") else "none" end' <<<"$wrangler_lines_json")"
  printf 'binding_usage_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$binding_usage_json")"
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --argjson vinextDependency "$(has_package vinext && echo true || echo false)" \
    --argjson wranglerFiles "$wrangler_files_json" \
    --argjson viteFiles "$vite_files_json" \
    --arg devScript "$(read_script_field dev)" \
    --arg buildScript "$(read_script_field build)" \
    --arg deployScript "$(read_script_field deploy)" \
    --argjson envFiles "$env_files_json" \
    --argjson wranglerMarkers "$wrangler_lines_json" \
    --argjson bindingUsageFiles "$binding_usage_json" \
    '{
      repo: $repo,
      vinextDependency: $vinextDependency,
      wranglerFiles: $wranglerFiles,
      viteFiles: $viteFiles,
      devScript: $devScript,
      buildScript: $buildScript,
      deployScript: $deployScript,
      envFiles: $envFiles,
      wranglerMarkers: $wranglerMarkers,
      bindingUsageFiles: $bindingUsageFiles
    }'
}

case "$format" in
  text)
    emit_text
    ;;
  json)
    emit_json
    ;;
  *)
    echo "unsupported format: $format" >&2
    exit 1
    ;;
esac
