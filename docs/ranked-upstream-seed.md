# Ranked upstream seed

Snapshot date: 2026-08-13

This is the fit ranking used to choose the first 50 upstream skills. It is not
a universal quality score. The ordering weights the recurring work observed
across the MacBook, `hetzner-bob`, and `labnuc`: evidence-first delivery,
TypeScript, architecture, debugging, releases, infrastructure, mobile work,
technical writing, and long-running multi-agent tasks.

The eligible pinned pool contains 80 skill folders: 44 from Cursor pstack, 35
from Matt Pocock's repository, and 1 from dmmulroy anti-slop. The exact source
commits, paths, tree hashes, tags, groups, and runtime support live in
[`catalog/upstream-sources.json`](../catalog/upstream-sources.json).

| Rank | Skill | Source |
| ---: | --- | --- |
| 1 | `unslop` | Cursor pstack |
| 2 | `principle-prove-it-works` | Cursor pstack |
| 3 | `diagnosing-bugs` | Matt Pocock |
| 4 | `blast-radius` | Cursor pstack |
| 5 | `figure-it-out` | Cursor pstack |
| 6 | `code-review` | Matt Pocock |
| 7 | `principle-boundary-discipline` | Cursor pstack |
| 8 | `install-anti-slop` | dmmulroy anti-slop |
| 9 | `principle-type-system-discipline` | Cursor pstack |
| 10 | `principle-fix-root-causes` | Cursor pstack |
| 11 | `domain-modeling` | Matt Pocock |
| 12 | `codebase-design` | Matt Pocock |
| 13 | `principle-sequence-verifiable-units` | Cursor pstack |
| 14 | `principle-build-the-lever` | Cursor pstack |
| 15 | `principle-never-block-on-the-human` | Cursor pstack |
| 16 | `principle-encode-lessons-in-structure` | Cursor pstack |
| 17 | `principle-guard-the-context-window` | Cursor pstack |
| 18 | `principle-subtract-before-you-add` | Cursor pstack |
| 19 | `principle-laziness-protocol` | Cursor pstack |
| 20 | `principle-foundational-thinking` | Cursor pstack |
| 21 | `principle-make-operations-idempotent` | Cursor pstack |
| 22 | `principle-minimize-reader-load` | Cursor pstack |
| 23 | `typescript-best-practices` | Cursor pstack |
| 24 | `tdd` | Cursor pstack |
| 25 | `technical-writing` | Cursor pstack |
| 26 | `how` | Cursor pstack |
| 27 | `why` | Cursor pstack |
| 28 | `architect` | Cursor pstack |
| 29 | `arena` | Cursor pstack |
| 30 | `interrogate` | Cursor pstack |
| 31 | `show-me-your-work` | Cursor pstack |
| 32 | `recall` | Cursor pstack |
| 33 | `create-verification-skill` | Cursor pstack |
| 34 | `maintain-verification-skill` | Cursor pstack |
| 35 | `wayfinder` | Matt Pocock |
| 36 | `improve-codebase-architecture` | Matt Pocock |
| 37 | `prototype` | Matt Pocock |
| 38 | `research` | Matt Pocock |
| 39 | `grilling` | Matt Pocock |
| 40 | `grill-with-docs` | Matt Pocock |
| 41 | `to-spec` | Matt Pocock |
| 42 | `to-tickets` | Matt Pocock |
| 43 | `triage` | Matt Pocock |
| 44 | `resolving-merge-conflicts` | Matt Pocock |
| 45 | `handoff` | Matt Pocock |
| 46 | `setup-pre-commit` | Matt Pocock |
| 47 | `wizard` | Matt Pocock |
| 48 | `writing-for-agents` | Matt Pocock |
| 49 | `setup-pstack` | Cursor pstack |
| 50 | `setup-matt-pocock-skills` | Matt Pocock |

## Selection notes

- `unslop` is in the always-enabled `core-quality` group. It remains the
  highest-priority prose skill.
- `install-anti-slop` is separate executable enforcement for TypeScript and
  JavaScript repositories. It activates through the `typescript-evidence`
  group.
- The pstack version of `tdd` won the duplicate skill-id collision because it
  allows a practical verification substitute when a failing test would need a
  large or brittle harness.
- Cursor-native orchestration skills remain vendored but are marked
  `supportedAgents: ["cursor"]` and placed in manual groups until their task,
  model, and MCP assumptions are adapted to a portable runtime.
- Issue publishing, merge-conflict resolution, and pre-commit installation are
  manual groups because they mutate external or project state.
- The catalog keeps all other engineering-principle groups selective. Only
  `unslop` and the small existing `core-quality` set load for every project.
