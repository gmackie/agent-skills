#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  inspect-domain-dns-surface.sh --repo /path/to/project [--format text|json]

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

domain_usage_json="$(
  rg -l --hidden --glob '!node_modules' --glob '!\.git' \
    'https?://|NEXT_PUBLIC_|APP_URL|SITE_URL|CNAME|MX|TXT|CAA|nameserver|dns' \
    "$repo" 2>/dev/null \
    | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

env_files_json="$(
  find "$repo" -maxdepth 1 \( -name '.env' -o -name '.env.*' \) -print 2>/dev/null \
    | sed "s|$repo/||" | sort -u | jq -R . | jq -s 'map(select(length > 0))'
)"

emit_text() {
  printf 'repo\t%s\n' "$repo"
  printf 'env_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$env_files_json")"
  printf 'domain_usage_files\t%s\n' "$(jq -r 'if length > 0 then join(",") else "none" end' <<<"$domain_usage_json")"
}

emit_json() {
  jq -cn \
    --arg repo "$repo" \
    --argjson envFiles "$env_files_json" \
    --argjson domainUsageFiles "$domain_usage_json" \
    '{repo: $repo, envFiles: $envFiles, domainUsageFiles: $domainUsageFiles}'
}

case "$format" in
  text) emit_text ;;
  json) emit_json ;;
  *) echo "unsupported format: $format" >&2; exit 1 ;;
esac
