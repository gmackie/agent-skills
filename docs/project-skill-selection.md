# Project skill selection

The catalog supports project-specific skill sets without making a UI or agent
runtime the source of truth.

## Data model

Four layers make the selection:

1. `skills/*/SKILL.md` carries portable string metadata for tags, groups,
   invocation, and upstream source so generic Agent Skills clients can see it.
2. `skills/*/skill.json` describes one skill with the richer local automation
   contract, including stable tags, group membership, supported agents, helper
   tools, and optional upstream provenance.
3. `catalog/installable-skills.json` defines named groups and their activation
   rules.
4. A project can add `.agent-skills.json` with detected or declared project
   tags plus explicit group and skill overrides.

The resolver combines those layers and emits a flat, deterministic selection:

```bash
./scripts/resolve-skill-selection.sh --policy /path/to/project/.agent-skills.json
```

The JSON result contains:

- normalized project tags
- enabled groups and why they were enabled
- final skill ids
- one decision record per known skill

## Project policy

```json
{
  "version": 1,
  "projectTags": ["typescript", "webapp"],
  "groupOverrides": {
    "architecture": "disabled",
    "typescript-evidence": "enabled"
  },
  "skillOverrides": {
    "prototype": "enabled",
    "show-me-your-work": "disabled"
  }
}
```

Allowed override states are `enabled` and `disabled`. Unknown group or skill
ids fail closed so renamed or stale policy entries stay visible.

## Activation modes

| Mode | Behavior |
| --- | --- |
| `always` | Enable for every project unless explicitly disabled. |
| `any-tag` | Enable when at least one configured tag matches. |
| `all-tags` | Enable only when every configured tag matches. |
| `manual` | Enable only through an explicit group override. |

## Future T3 Code plugin boundary

The plugin should remain a client of this contract. It can:

- detect project facts and propose tags
- let the user enable or disable groups and individual skills
- write `.agent-skills.json`
- call the resolver and explain each decision
- apply the resolved set to selected agent runtimes

The plugin should not maintain its own group definitions or selection rules.
That keeps CLI, CI, T3 Code, Codex, Claude, Cursor, and Grok on one catalog.

Automatic group rules are intentionally conservative. Broad project facts
such as `webapp`, `mobile`, or `infrastructure` do not opt a project into every
framework- or provider-specific workflow. The UI can propose narrower tags
such as `react`, `expo`, or `maestro`, and users can explicitly override any
group or individual skill.
