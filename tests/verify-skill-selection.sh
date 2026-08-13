#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sources="$root/catalog/upstream-sources.json"
groups="$root/catalog/installable-skills.json"
resolver="$root/scripts/resolve-skill-selection.sh"
policy="$root/tests/fixtures/typescript-project-skills.json"

test -f "$sources"
test -f "$groups"
test -x "$resolver"

jq -e '
  .version == 1 and
  .sources["cursor-pstack"].repository == "https://github.com/cursor/plugins" and
  .sources["cursor-pstack"].revision == "195d9359bdc2890f83745df69927528ad4538406" and
  .sources["mattpocock-skills"].repository == "https://github.com/mattpocock/skills" and
  .sources["mattpocock-skills"].revision == "84fdeffd12f2ee307994d1eb6feb48173b6e0502" and
  .sources["dmmulroy-anti-slop"].repository == "https://github.com/dmmulroy/anti-slop" and
  .sources["dmmulroy-anti-slop"].revision == "9b80d9a5c317d3af94d88a577bdbde4d9a45f7be" and
  (.imports | length) == 50 and
  ([.imports[].skillId] | unique | length) == 50
' "$sources" >/dev/null

expected_imports=(
  unslop
  create-verification-skill
  maintain-verification-skill
  recall
  principle-encode-lessons-in-structure
  principle-sequence-verifiable-units
  principle-guard-the-context-window
  show-me-your-work
  blast-radius
  principle-prove-it-works
  principle-boundary-discipline
  figure-it-out
  setup-matt-pocock-skills
  wayfinder
  domain-modeling
  codebase-design
  code-review
  diagnosing-bugs
  improve-codebase-architecture
  grilling
  prototype
  research
  wizard
  writing-for-agents
  install-anti-slop
  architect
  arena
  how
  why
  interrogate
  setup-pstack
  principle-build-the-lever
  principle-fix-root-causes
  principle-foundational-thinking
  principle-laziness-protocol
  principle-make-operations-idempotent
  principle-minimize-reader-load
  principle-never-block-on-the-human
  principle-subtract-before-you-add
  principle-type-system-discipline
  technical-writing
  typescript-best-practices
  grill-with-docs
  resolving-merge-conflicts
  tdd
  to-spec
  to-tickets
  triage
  handoff
  setup-pre-commit
)


if [[ "${#expected_imports[@]}" -ne 50 ]]; then
  echo "expected_imports list must contain exactly 50 skills" >&2
  exit 1
fi

actual_import_count="$(jq '.imports | length' "$sources")"
if [[ "$actual_import_count" -ne 50 ]]; then
  echo "expected 50 upstream imports, got $actual_import_count" >&2
  exit 1
fi

for skill_id in "${expected_imports[@]}"; do
  skill_dir="$root/skills/$skill_id"
  test -f "$skill_dir/SKILL.md"
  test -f "$skill_dir/skill.json"
  jq -e --arg id "$skill_id" '
    .id == $id and
    .kind == "skill" and
    (.tags | type == "array" and length > 0) and
    (.groupIds | type == "array" and length > 0) and
    (.invocation == "user" or .invocation == "model") and
    (.provenance.sourceId | type == "string" and length > 0) and
    (.provenance.sourceRevision | type == "string" and length == 40) and
    (.provenance.sourcePath | type == "string" and length > 0) and
    (.provenance.sourceTree | type == "string" and length == 40)
  ' "$skill_dir/skill.json" >/dev/null

  expected_tags="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .tags | join(",")' "$sources")"
  expected_groups="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .groupIds | join(",")' "$sources")"
  expected_agents="$(jq -c --arg id "$skill_id" '.imports[] | select(.skillId == $id) | (.supportedAgents // ["codex", "claude-code", "cursor", "grok"])' "$sources")"
  expected_tree="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .sourceTree' "$sources")"
  jq -e --argjson expected "$expected_agents" '.supportedAgents == $expected' "$skill_dir/skill.json" >/dev/null
  jq -e --arg expected "$expected_tree" '.provenance.sourceTree == $expected' "$skill_dir/skill.json" >/dev/null
  grep -Fq "  tags: \"$expected_tags\"" "$skill_dir/SKILL.md"
  grep -Fq "  groups: \"$expected_groups\"" "$skill_dir/SKILL.md"
  grep -Eq '^  invocation: "(user|model)"$' "$skill_dir/SKILL.md"
  grep -Fq '  source: "https://github.com/' "$skill_dir/SKILL.md"
  if rg -q '^disable-model-invocation:' "$skill_dir/SKILL.md"; then
    echo "$skill_id contains nonstandard disable-model-invocation frontmatter" >&2
    exit 1
  fi
done

while IFS= read -r skill_id; do
  skill_dir="$root/skills/$skill_id"
  metadata_file="$skill_dir/skill.json"
  test -f "$skill_dir/SKILL.md"
  test -f "$metadata_file"

  expected_tags="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .tags | join(",")' "$sources")"
  expected_groups="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .groupIds | join(",")' "$sources")"
  expected_tree="$(jq -r --arg id "$skill_id" '.imports[] | select(.skillId == $id) | .sourceTree' "$sources")"
  expected_agents="$(jq -c --arg id "$skill_id" '.imports[] | select(.skillId == $id) | (.supportedAgents // ["codex", "claude-code", "cursor", "grok"])' "$sources")"

  jq -e \
    --arg tags "$expected_tags" \
    --arg groups "$expected_groups" \
    --arg tree "$expected_tree" \
    --argjson agents "$expected_agents" '
      (.tags | join(",")) == $tags and
      (.groupIds | join(",")) == $groups and
      .provenance.sourceTree == $tree and
      .supportedAgents == $agents
    ' "$metadata_file" >/dev/null
  grep -Fq "  tags: \"$expected_tags\"" "$skill_dir/SKILL.md"
  grep -Fq "  groups: \"$expected_groups\"" "$skill_dir/SKILL.md"
done < <(jq -r '.imports[].skillId' "$sources")

jq -e '
  .version == 1 and
  ([.groups[].name] | index("core-quality")) != null and
  ([.groups[].name] | index("architecture")) != null and
  ([.groups[].name] | index("typescript-evidence")) != null and
  ([.groups[].activation.tags[]?] - ([.tagDefinitions | keys[]])) == []
' "$groups" >/dev/null

resolved="$($resolver --policy "$policy")"

jq -e '
  .version == 1 and
  (.projectTags | index("typescript")) != null and
  (.enabledGroupIds | index("core-quality")) != null and
  (.enabledGroupIds | index("typescript-evidence")) != null and
  (.enabledGroupIds | index("architecture")) == null and
  (.skillIds | index("unslop")) != null and
  (.skillIds | index("install-anti-slop")) != null and
  (.skillIds | index("prototype")) != null and
  (.skillIds | index("show-me-your-work")) == null and
  (.decisions[] | select(.id == "prototype" and .reason == "skill-override"))
' <<<"$resolved" >/dev/null

if diff -u <($resolver --policy "$policy") <($resolver --policy "$policy"); then
  :
else
  echo "skill selection resolver is not deterministic" >&2
  exit 1
fi

if "$resolver" --policy <(printf '%s\n' '{"version":1,"groupOverrides":{"missing-group":"enabled"}}') >/dev/null 2>&1; then
  echo "skill selection resolver accepted an unknown group override" >&2
  exit 1
fi

if "$resolver" --policy <(printf '%s\n' '{"version":1,"skillOverrides":{"unslop":"sometimes"}}') >/dev/null 2>&1; then
  echo "skill selection resolver accepted an invalid skill override state" >&2
  exit 1
fi

while IFS= read -r skill_id; do
  skill_dir="$root/skills/$skill_id"
  metadata_file="$skill_dir/skill.json"
  skill_file="$skill_dir/SKILL.md"
  test -f "$metadata_file"
  jq -e --arg id "$skill_id" '
    .id == $id and
    .kind == "skill" and
    (.tags | type == "array" and length > 0) and
    (.groupIds | type == "array" and length > 0) and
    (.supportedAgents | type == "array" and length > 0)
  ' "$metadata_file" >/dev/null

  metadata_tags="$(jq -r '.tags | join(",")' "$metadata_file")"
  metadata_groups="$(jq -r '.groupIds | join(",")' "$metadata_file")"
  grep -Fq "  tags: \"$metadata_tags\"" "$skill_file"
  grep -Fq "  groups: \"$metadata_groups\"" "$skill_file"
done < <(jq -r '.groups[].skillIds[]' "$groups" | sort -u)
