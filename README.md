# Agent Skills Library

This repo is a tracked source of truth for reusable agent skills and a smaller set of example agent definitions. The immediate goal is to keep the installable skill surface compatible with `npx skills` while growing stronger mobile, QA, and release-engineering coverage.

It is also being shaped into a canonical reference implementation of what an `agent-skills` repo should look like for individuals, teams, and orgs.

## Current Shape

The installable part of the repo is the `skills/` directory.

Each installable skill should live at:

```text
skills/<skill-name>/SKILL.md
```

`npx skills add . --list` currently detects the skills in this repo successfully.

The repo also carries pinned, attributed copies of selected upstream skills.
Their repository URLs, revisions, source paths, and import metadata live in
[`catalog/upstream-sources.json`](catalog/upstream-sources.json); license
notices are collected in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
The current upstream seed set vendors the top 50 skills selected from Cursor
pstack, Matt Pocock's skills, and dmmulroy anti-slop.
See [`docs/ranked-upstream-seed.md`](docs/ranked-upstream-seed.md) for the fit
ordering and selection notes.

The `agents/` directory is auxiliary. It contains example agent definitions, but the primary maintained artifact here should be reusable skills.

## Local Usage

List the skills available from this repo:

```bash
npx skills add . --list
```

Install one or more skills from this repo:

```bash
npx skills add . --skill expo-build-validation
npx skills add . --skill expo-build-submit --global
```

Install everything from this repo:

```bash
npx skills add . --skill '*'
```

Resolve the skill set for a tagged project:

```bash
./scripts/resolve-skill-selection.sh --policy /path/to/project/.agent-skills.json
```

See [`docs/project-skill-selection.md`](docs/project-skill-selection.md) for
group activation, overrides, and the future T3 Code plugin boundary.

## Repo Conventions

- Keep installable skills under `skills/<skill-name>/SKILL.md`.
- Add machine-readable metadata at `skills/<skill-name>/skill.json` when a skill has declarative dependency or bootstrap needs.
- Add `tags` and `groupIds` to metadata-backed skills that participate in project matching.
- Record vendored skill provenance in both `skill.json` and `catalog/upstream-sources.json`.
- Prefer minimal frontmatter: `name`, `description`, and the portable `metadata`
  strings needed for tags, groups, invocation, and optional provenance.
- Move large supporting material into `references/`.
- Put reusable automation in `scripts/`.
- Treat `docs/` as repo guidance, not skill payload.
- Avoid flat markdown files in `skills/` for new work; prefer skill folders.

## Nix Contract

This repo now includes a starter `flake.nix` and Home Manager module.

Current purpose:

- aggregate `skill.json` metadata from the repo
- aggregate `tool.json` metadata from the repo
- aggregate `agent-metadata.json` metadata from the repo
- expose `skillMetadata` as a flake output
- expose `toolMetadata` and packaged helper tools as flake outputs
- expose `agentMetadata` as a flake output
- expose `homeManagerModules.default` for declarative installation

The split is:

- `SKILL.md`: agent-facing instructions
- `skill.json`: machine-facing dependency and install metadata
- `tool.json`: machine-facing metadata for repo-owned helper tools
- `agent-metadata.json`: machine-facing metadata for agent definitions

Related generated catalog surfaces:

- [catalog/installable-skills.json](catalog/installable-skills.json)
- [catalog/smol-agent.reference.json](catalog/smol-agent.reference.json)

See:

- [docs/skill-metadata-contract.md](docs/skill-metadata-contract.md)
- [docs/nix-consumption-example.md](docs/nix-consumption-example.md)
- [flake.nix](flake.nix)
- [home-manager-module.nix](nix/home-manager-module.nix)

## Current Focus

The next area to build out is mobile development and QA:

- React Native / Expo release readiness
- Maestro-driven mobile QA
- App Store review preparation
- Better tracking of globally installed skills managed outside the repo
- Cross-project retrospective and skill-harvesting workflows
- x402 and `smol-agent` workflow support

See:

- [docs/mobile-skills-roadmap.md](docs/mobile-skills-roadmap.md)
- [docs/installed-global-skills.md](docs/installed-global-skills.md)

## Existing Skills

The canonical installable skill inventory lives in:

- [catalog/installable-skills.json](catalog/installable-skills.json)

That file is the source of truth for which skills are meant to be installable through `npx skills`. Repo docs and verification should point to it instead of duplicating skill lists by hand.

`smol-agent` can consume the same schema through the generated reference config at:

- [catalog/smol-agent.reference.json](catalog/smol-agent.reference.json)

## Notes

Some existing skills still reflect an older Kiro-style authoring format. They are installable today, but the repo should keep moving toward the simpler open skills layout used by `npx skills`.

See the reference-model docs:

- [docs/reference-repo-model.md](docs/reference-repo-model.md)
- [docs/runtime-integration-model.md](docs/runtime-integration-model.md)

## Next Steps

The highest-value additions from here are:

- source-refresh automation for the 50 pinned upstream imports
- a generated merged catalog across public and private repos
- more public workflow skills harvested from real `smol-agent`, x402, and adjacent repo work

See:

- [docs/cloudflare-next-skill-opportunities.md](docs/cloudflare-next-skill-opportunities.md)
- [docs/skill-source-inventory.md](docs/skill-source-inventory.md)
- [docs/reference-repo-model.md](docs/reference-repo-model.md)
- [docs/runtime-integration-model.md](docs/runtime-integration-model.md)
