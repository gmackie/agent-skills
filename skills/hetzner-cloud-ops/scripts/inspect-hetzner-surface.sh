#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  inspect-hetzner-surface.sh --repo /path/to/project [--format text|json]

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

usage_files_json="$(
  rg -l --hidden --glob '!node_modules' --glob '!\.git' \
    'hcloud|hetzner|provider "hcloud"|cloud-init|user-data|floating_ip|firewall' \
    "$repo" 2>/dev/null \
    | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

bootstrap_files_json="$(
  find "$repo" \
    \( -name 'cloud-init*' -o -name '*user-data*' -o -name 'docker-compose*.yml' -o -name 'docker-compose*.yaml' -o -name 'compose*.yml' -o -name 'compose*.yaml' -o -name 'Caddyfile' -o -name 'caddy*.json' -o -name 'traefik*.yml' -o -name 'traefik*.yaml' \) \
    -print 2>/dev/null \
    | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'usage_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$usage_files_json")"
  printf 'bootstrap_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$bootstrap_files_json")"
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --argjson usageFiles "$usage_files_json" \
    --argjson bootstrapFiles "$bootstrap_files_json" \
    '{repo: $repo, usageFiles: $usageFiles, bootstrapFiles: $bootstrapFiles}'
}

case "$format" in
  text) emit_text ;;
  json) emit_json ;;
  *) echo "unsupported format: $format" >&2; exit 1 ;;
esac
