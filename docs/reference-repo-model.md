# Reference Repo Model

Snapshot date: 2026-03-29

This repo is evolving into a canonical reference implementation for the `agent-skills` pattern.

The goal is not just to host one person's skills. The goal is to show what a serious, standards-first `agent-skills` repo should look like on GitHub and how it should be consumed by models, tools, and end users.

## Core Position

Every serious user, team, or org should be able to have an `agent-skills` repo.

That repo should:

- be installable with `npx skills`
- work as a source of truth for custom skills and agent definitions
- expose machine-readable metadata for automation and packaging
- be adaptable to multiple runtimes without rewriting the skills for each one

This repo is the reference implementation of that idea.

## Branch Model

The intended public branch model is:

- `main`
- `reference`
- `private`

### `main`

`main` is the public default branch.

It should always point at the current recommended reference state for the repo. For practical purposes, it tracks the same content as `reference` unless there is a temporary reason to stage a reference update first.

### `reference`

`reference` is the explicit branch that says:

this is the canonical public reference implementation of an `agent-skills` repo.

It exists so the repo can talk clearly about itself as a reference pattern, not just as one active working branch.

### `private`

`private` is intentionally public in this repo.

It is **not** for real private skills.

Its purpose is to document and model how a private companion repo should work:

- shared folder structure
- shared metadata contract
- shared Nix/Home Manager patterns
- shared runtime adapter patterns

This is by design. The branch demonstrates the convention without storing sensitive material.

## Public / Private Recommendation

The recommended real-world deployment model is still:

- `agent-skills` as a public repo
- `agent-skills-private` as a separate private repo

Why:

- GitHub branch visibility is repo-wide
- real private skills should not rely on branch discipline
- public and private repos can still share the same contract cleanly

This reference repo should repeatedly make that recommendation explicit.

## What The Reference Repo Should Contain

It should contain:

- basic reference skills
- basic agent definitions
- reference docs for packaging and installation
- examples of runtime adapters
- examples of public/private split patterns

It should not depend on one model vendor or one agent runtime to make sense.

## What “First-Class” Means

`agent-skills` becomes first-class when:

- users can install from it directly
- tools can discover skills from it predictably
- runtimes can adapt it without forking the content model
- teams can copy the pattern for their own orgs

This means the repo is more important than any single plugin or CLI.

## Reference Contract

At minimum, the reference repo should keep demonstrating:

- `skills/<skill-name>/SKILL.md`
- `skills/<skill-name>/skill.json`
- optional `scripts/`
- optional `references/`
- `agents/`
- `tools/`
- `docs/`
- `flake.nix`

That contract is already present in this repo and should remain stable unless there is a strong reason to change it.

## What To Do Next

Short-term:

- keep `main` and `reference` aligned
- use `private` as a documentation branch, not a secret-content branch
- keep adding a few high-quality reference skills instead of a giant pile of half-maintained ones

Long-term:

- document runtime integrations more explicitly
- add a small OpenClaw adapter example
- add a merged public/private catalog example
