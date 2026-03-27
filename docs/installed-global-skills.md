# Installed Global Skills

Snapshot date: 2026-03-26

This file tracks skills currently installed outside this repo through `npx skills` or direct user-level skill directories.

## Why This Exists

This repo should be the git-tracked source of truth for skills and agent prompts we want to keep, evolve, and share.

Global installs live elsewhere:

- `~/.agents/skills`
- `~/.claude/skills`
- `~/.codex/skills`
- `~/.config/agents/skills`

That makes it easy to lose sight of what is actually active on the machine. This file is the human-readable inventory.

## Current Global Skill Inventory

Output source: `npx skills ls -g`

### Shared / Multi-agent installs

- `api-design-principles`
- `app-store-review`
- `find-skills`
- `vercel-composition-patterns`
- `vercel-react-best-practices`
- `vercel-react-native-skills`
- `web-design-guidelines`

### Claude Code installs

- `create-gmacko-app-workflow`
- `esp32-firmware-development`
- `gmac-deployments-e2e`
- `gmac-deployments-index`
- `gmac-feature-delivery-loop`
- `gmac-incident-rollback`
- `gstack`
- `peon-ping-config`
- `peon-ping-toggle`
- `tasks-gmac-mcp`

### Codex installs

- `brand-domain-naming`
- `migrate-to-vinext`

## Working Convention

- Keep reusable skill source in this repo.
- Install from this repo with `npx skills add <repo-or-path>`.
- Treat user-directory installs as deployment targets, not authoring locations.
- When a skill matters enough to maintain, add or move it into this repo and update this file.

## Maintenance Commands

```bash
npx skills ls -g
ls -la ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.config/agents/skills
```
