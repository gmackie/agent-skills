#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  inspect-d1-development.sh --repo /path/to/project [--format text|json]

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

wrangler_file=""
if [[ -f "$repo/wrangler.jsonc" ]]; then
  wrangler_file="$repo/wrangler.jsonc"
elif [[ -f "$repo/wrangler.toml" ]]; then
  wrangler_file="$repo/wrangler.toml"
fi

extract_lines_json() {
  local pattern="$1"
  if [[ -n "$wrangler_file" ]]; then
    rg -n "$pattern" "$wrangler_file" 2>/dev/null \
      | sed "s|$repo/||" \
      | jq -R . \
      | jq -s 'map(select(length > 0))'
  else
    printf '[]'
  fi
}

migration_files_json="$(
  find "$repo" \
    \( -path '*/migrations/*.sql' -o -path '*/drizzle/*.sql' -o -path '*/db/migrations/*.sql' -o -path '*/sql/*.sql' \) \
    -type f -print 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
)"

seed_files_json="$(
  find "$repo" \
    \( -iname '*seed*.sql' -o -iname '*seed*.ts' -o -iname '*seed*.js' \) \
    -type f -print 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
)"

d1_usage_files_json="$(
  rg -l --hidden --glob '!node_modules' --glob '!\.git' \
    'prepare\\(|batch\\(|exec\\(|\\.withSession\\(|D1Database|env\\.[A-Z0-9_]+.*prepare\\(' \
    "$repo" 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
)"

d1_lines_json="$(extract_lines_json 'd1_databases|preview_database_id')"
remote_lines_json="$(extract_lines_json 'remote\\s*=|\"remote\"\\s*:')"
env_sections_json="$(extract_lines_json '(^|\\s)(\\[env\\.|\"env\"\\s*:|env\\s*=)')"

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'wrangler_file\t%s\n' "${wrangler_file#$repo/}"
  printf 'd1_markers\t%s\n' "$(jq -r 'if length > 0 then join(" | ") else "none" end' <<<"$d1_lines_json")"
  printf 'remote_markers\t%s\n' "$(jq -r 'if length > 0 then join(" | ") else "none" end' <<<"$remote_lines_json")"
  printf 'env_sections\t%s\n' "$(jq -r 'if length > 0 then join(" | ") else "none" end' <<<"$env_sections_json")"
  printf 'migration_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$migration_files_json")"
  printf 'seed_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$seed_files_json")"
  printf 'd1_usage_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$d1_usage_files_json")"
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --arg wranglerFile "${wrangler_file#$repo/}" \
    --argjson d1Markers "$d1_lines_json" \
    --argjson remoteMarkers "$remote_lines_json" \
    --argjson envSections "$env_sections_json" \
    --argjson migrationFiles "$migration_files_json" \
    --argjson seedFiles "$seed_files_json" \
    --argjson d1UsageFiles "$d1_usage_files_json" \
    '{
      repo: $repo,
      wranglerFile: $wranglerFile,
      d1Markers: $d1Markers,
      remoteMarkers: $remoteMarkers,
      envSections: $envSections,
      migrationFiles: $migrationFiles,
      seedFiles: $seedFiles,
      d1UsageFiles: $d1UsageFiles
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
