#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
catalog="$root/catalog/installable-skills.json"
policy="/dev/null"

usage() {
  cat <<'USAGE'
Usage: resolve-skill-selection.sh [--catalog PATH] [--policy PATH]

Resolve project tags and explicit overrides into a deterministic skill set.
The default policy is empty, which enables only groups whose activation mode
is "always". Project policy files normally live at .agent-skills.json.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --catalog)
      catalog="${2:?--catalog requires a path}"
      shift 2
      ;;
    --policy)
      policy="${2:?--policy requires a path}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

test -r "$catalog"
test -r "$policy"

jq -n \
  --slurpfile catalog "$catalog" \
  --slurpfile policy "$policy" '
  def activation_decision($activation; $projectTags):
    ($activation.mode // "manual") as $mode
    | if $mode == "always" then
        {enabled: true, reason: "always", matchedTags: []}
      elif $mode == "manual" then
        {enabled: false, reason: "manual", matchedTags: []}
      elif $mode == "any-tag" then
        [($activation.tags // [])[] as $tag
          | select($projectTags | index($tag) != null)
          | $tag] as $matches
        | {
            enabled: ($matches | length) > 0,
            reason: (if ($matches | length) > 0 then "tag-match" else "no-tag-match" end),
            matchedTags: $matches
          }
      elif $mode == "all-tags" then
        ($activation.tags // []) as $required
        | [$required[] as $tag
            | select($projectTags | index($tag) != null)
            | $tag] as $matches
        | {
            enabled: (($required | length) > 0 and ($matches | length) == ($required | length)),
            reason: (if (($required | length) > 0 and ($matches | length) == ($required | length)) then "tag-match" else "no-tag-match" end),
            matchedTags: $matches
          }
      else
        error("unsupported activation mode: \($mode)")
      end;

  def selected_group($skillId; $groups):
    first($groups[]
      | select(.enabled == true and (.skillIds | index($skillId) != null))
      | .id) // null;

  ($catalog[0]) as $catalog
  | ($policy[0] // {
      version: 1,
      projectTags: [],
      groupOverrides: {},
      skillOverrides: {}
    }) as $policy
  | ($policy.projectTags // [] | unique | sort) as $projectTags
  | ($policy.groupOverrides // {}) as $groupOverrides
  | ($policy.skillOverrides // {}) as $skillOverrides
  | ([$catalog.groups[].name] | unique | sort) as $knownGroupIds
  | ([$catalog.groups[].skillIds[]] | unique | sort) as $knownSkillIds
  | ([$groupOverrides | to_entries[]
      | select(.key as $id | $knownGroupIds | index($id) == null)
      | .key]) as $unknownGroupOverrides
  | ([$skillOverrides | to_entries[]
      | select(.key as $id | $knownSkillIds | index($id) == null)
      | .key]) as $unknownSkillOverrides
  | ([$groupOverrides | to_entries[]
      | select(.value != "enabled" and .value != "disabled")
      | .key]) as $invalidGroupStates
  | ([$skillOverrides | to_entries[]
      | select(.value != "enabled" and .value != "disabled")
      | .key]) as $invalidSkillStates
  | if ($unknownGroupOverrides | length) > 0 then
      error("unknown group override(s): \($unknownGroupOverrides | join(", "))")
    elif ($unknownSkillOverrides | length) > 0 then
      error("unknown skill override(s): \($unknownSkillOverrides | join(", "))")
    elif ($invalidGroupStates | length) > 0 then
      error("invalid group override state(s): \($invalidGroupStates | join(", "))")
    elif ($invalidSkillStates | length) > 0 then
      error("invalid skill override state(s): \($invalidSkillStates | join(", "))")
    else
      [$catalog.groups[]
        | . as $group
        | activation_decision(($group.activation // {mode: "manual"}); $projectTags) as $automatic
        | ($groupOverrides[$group.name] // null) as $override
        | {
            id: $group.name,
            label: ($group.label // $group.name),
            enabled: (
              if $override == "enabled" then true
              elif $override == "disabled" then false
              else $automatic.enabled
              end
            ),
            reason: (if $override != null then "group-override" else $automatic.reason end),
            matchedTags: $automatic.matchedTags,
            skillIds: $group.skillIds
          }] as $groupDecisions
      | [$knownSkillIds[]
          | . as $skillId
          | ($skillOverrides[$skillId] // null) as $override
          | selected_group($skillId; $groupDecisions) as $groupId
          | if $override == "enabled" then
              {id: $skillId, enabled: true, reason: "skill-override", groupId: $groupId}
            elif $override == "disabled" then
              {id: $skillId, enabled: false, reason: "skill-override", groupId: $groupId}
            elif $groupId != null then
              {id: $skillId, enabled: true, reason: "group", groupId: $groupId}
            else
              {id: $skillId, enabled: false, reason: "not-selected", groupId: null}
            end] as $skillDecisions
      | {
          version: 1,
          catalogVersion: $catalog.version,
          projectTags: $projectTags,
          enabledGroupIds: [$groupDecisions[] | select(.enabled) | .id],
          skillIds: [$skillDecisions[] | select(.enabled) | .id],
          groups: $groupDecisions,
          decisions: $skillDecisions
        }
    end
'
