# Skills Distribution Model

Snapshot date: 2026-03-26

This document defines how this repo should work as the source of truth for custom skills, agent definitions, and supporting tools, while still being easy to install onto new systems with `npx skills`.

## Goal

Use this repo as:

- the canonical git-tracked source for custom skills
- the canonical source for agent definitions and supporting helper tools
- the install source for new laptops, CI runners, and fresh development environments

The install target should be user-level or project-level agent skill directories managed by `npx skills`.

## What `npx skills` Supports Today

Based on the current `vercel-labs/skills` documentation, the CLI supports installing from:

- GitHub shorthand, for example `owner/repo`
- full GitHub URLs
- direct paths to a skill inside a repository
- GitLab URLs
- arbitrary git URLs
- local filesystem paths

That means this repo already has a viable private and public distribution story without waiting for a separate registry feature.

## Important Distinction

There are two different problems:

1. Installation
2. Discovery

Installation is already solved by `npx skills add <repo-or-path>`.

Discovery is the part tied to public directories like `skills.sh`, search UX, and any future registry model.

Do not block the repo architecture on public discovery.

## Recommended Distribution Strategy

### Default model

Use this repo itself as the registry-like source of truth.

Examples:

```bash
npx skills add git@github.com:your-org/agent-skills.git --skill mobile-maestro-qa-report
npx skills add https://github.com/your-org/agent-skills --skill expo-build-validation
npx skills add /path/to/agent-skills --skill react-native-expo-release-readiness
```

This is enough for:

- public open-source sharing
- private org-internal sharing
- machine bootstrap scripts
- local iteration before publishing

### Private distribution

For private skills, the practical path today is:

- keep the repo private
- install via GitHub SSH URL or another authenticated git URL
- ensure the target machine already has git host credentials configured

Inference from the official docs:

- because `npx skills` accepts arbitrary git URLs, private distribution should work through standard git authentication
- this is a git-hosting concern, not a separate `skills` registry feature

That is an inference from source-format support, not an explicit promise of a private registry product.

## Public Discovery Strategy

If a skill should be broadly discoverable:

- keep it in a public repo
- give it strong `name` and `description` metadata
- optionally structure public-ready skills under `skills/.curated/` or `skills/`
- consider publishing or mirroring the public subset separately if the main repo will also contain private/internal material

## Internal / Private Skills

The official CLI supports hidden internal skills via frontmatter:

```yaml
metadata:
  internal: true
```

Those skills are only shown when `INSTALL_INTERNAL_SKILLS=1` is set.

Use this for:

- work in progress skills
- internal-only helpers
- org-specific workflows you do not want shown by default

Important limitation:

- this hides skills from normal discovery and listing behavior
- it is not the same thing as a custom private registry

## Custom Registry Status

Current finding: I do not see official first-class support in `npx skills` docs for defining a custom registry endpoint analogous to npm registries.

What is documented:

- install from repo URLs and git URLs
- discover public skills through `skills.sh`
- hide internal skills with `metadata.internal`

What I have not verified from primary sources:

- custom registry endpoints for `npx skills`
- org-scoped registry configuration
- self-hosted skills index integration built into the CLI

So the safe conclusion is:

- use git repositories as the supported distribution primitive today
- treat any “custom registry” effort as a separate layer we would build ourselves

## Practical Architecture For This Repo

Recommended split:

- `skills/`: installable skills
- `agents/`: agent definitions and prompts
- `tools/`: helper CLIs, scripts, wrappers used by skills
- `docs/`: repo-only planning and operating docs

Suggested shape:

```text
agent-skills/
├── skills/
│   ├── .curated/
│   ├── .experimental/
│   ├── .system/
│   └── <skill-name>/
├── agents/
├── tools/
└── docs/
```

This gives you a clean path for:

- stable skills
- experimental skills
- system/meta skills
- agent definitions and custom tooling in the same repo

## Bootstrap Story For New Systems

Use one bootstrap command plus a small shell script.

Example shape:

```bash
npx skills add git@github.com:your-org/agent-skills.git --global --agent codex --skill '*'
```

Then separately bootstrap helper tools from this repo if needed.

If the repo contains scripts or binaries that skills depend on, they should either:

- be directly invokable from the repo after cloning, or
- have a separate install script in `tools/` that the machine bootstrap runs

## Recommended Near-Term Plan

1. Keep this repo as the canonical source for all custom skills.
2. Add a `tools/` directory for helper binaries and wrappers used by those skills.
3. Split public-shareable and internal-only skills using `skills/`, `skills/.curated/`, and `metadata.internal`.
4. If needed, create a second public mirror repo for the subset meant for `skills.sh` visibility.
5. Do not wait for official custom registry support before standardizing this repo.

## Working Conclusion

The repo can already serve as your install source for new systems.

The missing piece is not installation. The missing piece is choosing how much of the repo is:

- public and discoverable
- private but git-installable
- internal and hidden by default

That is primarily an information architecture decision, not a blocker in the `npx skills` tool itself.
