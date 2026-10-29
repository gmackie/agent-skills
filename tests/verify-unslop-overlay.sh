#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

overlay_mode="vendored-with-frontmatter-metadata-and-unslop-overlay"

jq -e --arg mode "$overlay_mode" '.importPolicy == $mode' catalog/upstream-sources.json >/dev/null
test -f docs/unslop-overlay.md

imported_count=0
for metadata in skills/*/skill.json; do
  source_id="$(jq -r '.provenance.sourceId // empty' "$metadata")"
  case "$source_id" in
    theo-tstack|cursor-pstack|mattpocock-skills|dmmulroy-anti-slop|expo-skills|anthropic-skills|cloudflare-skills|microsoft-playwright-cli|supabase-agent-skills|turso-agent-skills)
      jq -e --arg mode "$overlay_mode" '.provenance.importMode == $mode' "$metadata" >/dev/null
      imported_count=$((imported_count + 1))
      ;;
  esac
done

expected_count="$(jq '.imports | length' catalog/upstream-sources.json)"
if [[ "$imported_count" -ne "$expected_count" ]]; then
  printf 'Expected %s upstream imports with the unslop overlay, found %s.\n' "$expected_count" "$imported_count" >&2
  exit 1
fi

printf 'Unslop provenance overlay is recorded for %s upstream skills.\n' "$imported_count"
