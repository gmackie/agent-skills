#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  inspect-sentry-surface.sh --repo /path/to/project [--format text|json]

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
    --repo) repo="${2:-}"; shift 2 ;;
    --format) format="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

[[ -n "$repo" ]] || { echo "--repo is required" >&2; usage >&2; exit 1; }
[[ -d "$repo" ]] || { echo "repo not found: $repo" >&2; exit 1; }
repo="$(cd "$repo" && pwd)"

has_package() {
  local package_name="$1"
  [[ -f "$repo/package.json" ]] || return 1
  jq -e --arg package_name "$package_name" '
    (.dependencies // {})[$package_name] != null or
    (.devDependencies // {})[$package_name] != null
  ' "$repo/package.json" >/dev/null
}

files_json() {
  find "$repo" -maxdepth 2 "$@" -print 2>/dev/null \
    | sed "s|$repo/||" \
    | sort -u \
    | jq -R . \
    | jq -s 'map(select(length > 0))'
}

config_files_json="$(files_json \( -name 'sentry*.config.*' -o -name 'instrument.*' \))"
env_files_json="$(files_json -maxdepth 1 \( -name '.env' -o -name '.env.*' \))"
usage_files_json="$(
  rg -l --hidden --glob '!node_modules' --glob '!\.git' \
    'Sentry\.init|captureException|captureMessage|ErrorBoundary|sentry-cli|sourcemaps upload|release:' \
    "$repo" 2>/dev/null \
    | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'sentry_package\t%s\n' "$(has_package '@sentry/browser' && echo present || has_package '@sentry/nextjs' && echo present || has_package '@sentry/node' && echo present || echo missing)"
  printf 'config_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$config_files_json")"
  printf 'env_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$env_files_json")"
  printf 'usage_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$usage_files_json")"
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --argjson sentryPackage "$(has_package '@sentry/browser' && echo true || has_package '@sentry/nextjs' && echo true || has_package '@sentry/node' && echo true || echo false)" \
    --argjson configFiles "$config_files_json" \
    --argjson envFiles "$env_files_json" \
    --argjson usageFiles "$usage_files_json" \
    '{repo: $repo, sentryPackage: $sentryPackage, configFiles: $configFiles, envFiles: $envFiles, usageFiles: $usageFiles}'
}

case "$format" in
  text) emit_text ;;
  json) emit_json ;;
  *) echo "unsupported format: $format" >&2; exit 1 ;;
esac
