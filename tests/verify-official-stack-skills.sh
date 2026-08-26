#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sources="$root/catalog/upstream-sources.json"
groups="$root/catalog/installable-skills.json"

expected_sources=(
  anthropic-skills
  cloudflare-skills
  expo-skills
  microsoft-playwright-cli
  supabase-agent-skills
  turso-agent-skills
)

expo_skills=(
  eas-app-stores eas-hosting eas-observe eas-simulator eas-update-insights eas-workflows
  expo-animation expo-app-clip expo-brownfield expo-data-fetching expo-design-system
  expo-dev-client expo-dom expo-examples expo-module expo-native-ui expo-overview
  expo-project-structure expo-router expo-skill-feedback expo-tailwind-setup expo-ui
  expo-upgrade expo-web-to-native
)

stack_skills=(
  cloudflare durable-objects workers-best-practices
  playwright-cli webapp-testing
  supabase-postgres-best-practices turso-db
)

for source_id in "${expected_sources[@]}"; do
  jq -e --arg id "$source_id" '
    (.sources[$id].repository // "") | startswith("https://github.com/")
  ' "$sources" >/dev/null
  jq -e --arg id "$source_id" '
    .sources[$id].revision | type == "string" and length == 40
  ' "$sources" >/dev/null
done

for skill_id in "${expo_skills[@]}" "${stack_skills[@]}"; do
  skill_dir="$root/skills/$skill_id"
  test -f "$skill_dir/SKILL.md"
  test -f "$skill_dir/skill.json"
  jq -e --arg id "$skill_id" '
    .id == $id and
    .kind == "skill" and
    (.tags | type == "array" and length > 0) and
    (.groupIds | type == "array" and length > 0) and
    (.supportedAgents == ["codex", "claude-code", "cursor", "grok"]) and
    (.provenance.sourceRevision | type == "string" and length == 40) and
    (.provenance.sourceTree | type == "string" and length == 40)
  ' "$skill_dir/skill.json" >/dev/null

  metadata_tags="$(jq -r '.tags | join(",")' "$skill_dir/skill.json")"
  metadata_groups="$(jq -r '.groupIds | join(",")' "$skill_dir/skill.json")"
  grep -Fq "  tags: \"$metadata_tags\"" "$skill_dir/SKILL.md"
  grep -Fq "  groups: \"$metadata_groups\"" "$skill_dir/SKILL.md"
  grep -Eq '^  invocation: "(user|model)"$' "$skill_dir/SKILL.md"
  grep -Fq '  source: "https://github.com/' "$skill_dir/SKILL.md"

  if rg -q '^allowed-tools:|^disable-model-invocation:|\$\{CLAUDE_PLUGIN_ROOT\}' "$skill_dir/SKILL.md"; then
    echo "$skill_id contains non-portable skill metadata or paths" >&2
    exit 1
  fi
done

for skill_id in "${expo_skills[@]}"; do
  grep -Fq 'Only run this external write after explicit user authorization.' "$root/skills/$skill_id/SKILL.md"
  jq -e --arg id "$skill_id" '.groups[] | select(.name == "expo") | .skillIds | index($id) != null' "$groups" >/dev/null
done

jq -e '
  (.groups[] | select(.name == "playwright") | .skillIds | sort) == ["playwright-cli", "webapp-testing"] and
  (.groups[] | select(.name == "database") | .skillIds | sort) == ["supabase-postgres-best-practices", "turso-db"] and
  (.groups[] | select(.name == "unity") | .skillIds | sort) == ["unity-debug-workflow", "unity-project-setup", "unity-scripting-advanced"]
' "$groups" >/dev/null

for license_file in \
  expo-skills/LICENSE \
  anthropic-webapp-testing/LICENSE.txt \
  cloudflare-skills/LICENSE \
  microsoft-playwright-cli/LICENSE \
  supabase-agent-skills/LICENSE \
  turso-agent-skills/LICENSE; do
  test -s "$root/third-party/$license_file"
done
