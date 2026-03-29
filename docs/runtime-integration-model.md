# Runtime Integration Model

Snapshot date: 2026-03-29

This note describes how `agent-skills` should integrate with models, user tooling, and runtime adapters without becoming locked to one environment.

## Core Principle

`agent-skills` should be runtime-agnostic at the content layer.

The repo is the canonical source of:

- skill instructions
- agent definitions
- helper tools
- machine-readable metadata

Each runtime or product should adapt that content through a thin integration layer rather than requiring a different repo shape.

## Three Layers

### 1. Content Layer

This repo:

- `SKILL.md`
- `skill.json`
- `tools/`
- `agents/`
- `docs/`

This layer should stay portable.

### 2. Packaging Layer

This repo already exposes:

- `npx skills` compatibility
- Nix flake outputs
- Home Manager integration

This is the bridge between repo content and installable user/system state.

### 3. Runtime Adapter Layer

Examples:

- OpenClaw plugin output
- `t3-code` integration
- Bob integration
- `smol-agent` integration
- other agent CLIs and routers

This layer should be thin. It should select, install, or expose skills. It should not redefine them.

## Model-Level Use

Models should consume `agent-skills` by discovering and loading skills, not by treating the repo as a giant prompt blob.

Good model behavior:

- use metadata to decide what to load
- load the minimum relevant `SKILL.md`
- load references only when needed
- use helper scripts instead of retyping deterministic steps

That is why the repo emphasizes:

- minimal frontmatter
- concise skill bodies
- references for heavier detail
- scripts for deterministic operations

## User-Level Use

For end users, the baseline path should be simple:

```bash
npx skills add github:gmackorg/agent-skills --skill '*'
```

Or one skill at a time:

```bash
npx skills add github:gmackorg/agent-skills --skill maestro-qa-report
```

For users with a public + private setup, the conceptual model is:

1. install public skills
2. install private skills from a separate repo
3. let local runtime/tooling merge the two surfaces

## Runtime Adapters

### OpenClaw

OpenClaw should treat `agent-skills` as content and provide a plugin adapter around it.

Good shape:

- an `openclawPlugin` output
- selected packages and helper tools
- selected skills surfaced into OpenClaw

The plugin is the adapter. The repo remains the source of truth.

### `t3-code`

`t3-code` should consume skills as a curated workflow layer for full-stack web development.

The integration should probably:

- install a curated subset of public skills
- expose app-framework-specific helpers
- avoid inventing a second skill format

### Bob

Bob should consume `agent-skills` the same way:

- prefer install and discovery over copy-paste prompts
- treat the repo as a shared skills/catalog source
- add only a thin Bob-specific adapter if Bob needs one

### `smol-agent`

`smol-agent` should use `agent-skills` as externalized operational knowledge.

That means:

- `smol-agent` should not own the canonical source of reusable skills
- it should reference installed skills by name or load them from the repo contract
- project-specific `smol-agent` conventions should remain local when they are not generally reusable

## Why This Matters

If every runtime forks the skill format, the ecosystem fragments immediately.

If every runtime adapts the same repo contract, then:

- users have one place to author skills
- teams can publish public and private repos cleanly
- runtimes compete on adapter quality, not on inventing incompatible content models

That is the right ecosystem shape.

## Reference Recommendation

The reference repo should keep teaching this pattern:

1. author in `agent-skills`
2. publish public/private repos separately
3. install with `npx skills` or Nix/Home Manager
4. adapt to runtimes with thin plugins or adapter layers

## Next Integration Work

The next useful implementation steps are:

- document an OpenClaw adapter example
- add a sample adapter surface for `smol-agent`
- show how curated subsets of skills could be exposed to other runtimes like `t3-code` and Bob
