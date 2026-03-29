---
name: vinext-cloudflare-hardening
description: Use when a vinext project already builds or runs, but the Cloudflare deployment surface still needs hardening. Reviews Wrangler config, assets and image bindings, cache strategy, environment boundaries, and production-risk gaps, then writes a concrete hardening plan before deploy work.
---

# vinext Cloudflare Hardening

## Overview

Use this skill after vinext adoption, when the project is already on the path to Cloudflare Workers and the problem is hardening, not migration.

This skill focuses on:

- Wrangler and deployment config
- assets and image bindings
- cache and persistence strategy
- environment drift
- production-risk review before deploy

If the repo is still on Next.js, use [migrate-to-vinext](../migrate-to-vinext/SKILL.md) first.

## Default Workflow

### 1. Confirm the skill applies

Verify that the repo is already a vinext project:

- `package.json` depends on `vinext`
- `vite.config.*` exists
- scripts or docs mention `vinext dev`, `vinext build`, or `vinext deploy`

If not, stop and route to `migrate-to-vinext`.

### 2. Inventory the Cloudflare deployment surface

Start with the helper:

```bash
skills/vinext-cloudflare-hardening/scripts/inspect-vinext-cloudflare.sh \
  --repo /path/to/project
```

Use it to identify:

- `wrangler.jsonc` or `wrangler.toml`
- `vite.config.*`
- `vinext` scripts in `package.json`
- asset and image bindings
- KV or cache-related bindings
- environment files and deployment markers

### 3. Check the Cloudflare hardening boundary

Review the repo for common post-migration gaps:

- assets binding exists when static asset serving needs it
- image handling expectations are explicit
- cache strategy is intentional, especially for ISR-like behavior
- worker size and dependency weight risks are visible
- environment and secret handling match the Worker model

Do not treat a successful dev start as proof that deployment is hardened.

### 4. Check app and config drift

Compare code and config for:

- cache handlers that imply KV but no KV binding
- asset usage without an assets binding
- image expectations without image handling configuration
- deployment scripts that drift from actual Wrangler config

### 5. Produce a hardening plan

Write a concise plan with:

- current deployment shape
- missing bindings or config
- cache and persistence concerns
- environment or secret risks
- the narrowest safe next hardening step

Default output location:

```text
docs/cloudflare/YYYY-MM-DD-vinext-hardening.md
```

## Output Contract

Minimum sections:

- summary
- current deployment surface
- binding and asset review
- cache and persistence review
- drift and risk findings
- next steps

## Quick Reference

| Need | Action |
| --- | --- |
| confirm the repo is really vinext | inspect package and scripts |
| inventory deployment shape | run the helper |
| review static assets and images | inspect Wrangler and app expectations |
| review cache behavior | check cache handlers and related bindings |

## Common Mistakes

- treating vinext migration completion as production hardening
- forgetting assets or image-related bindings
- using persistence or cache features without the backing binding
- shipping Worker config drift between local, preview, and production
- using this skill before the repo has actually adopted vinext
