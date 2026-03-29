---
name: cloudflare-d1-development
description: Use when adding, debugging, or hardening Cloudflare D1 usage in a Workers app. Inventories Wrangler D1 configuration, local-vs-remote database assumptions, migration and seeding workflow, and app-level access patterns, then produces a concrete development plan before deeper implementation work.
---

# Cloudflare D1 Development

## Overview

Use this skill when a Cloudflare project depends on D1 and the main question is not generic SQL design, but how D1 should be configured and used during development.

This skill focuses on:

- D1 binding declarations
- local and remote development behavior
- migration and seed workflow
- query access patterns in app code

It complements, but does not replace, broader binding review from [cloudflare-workers-bindings-local-dev](../cloudflare-workers-bindings-local-dev/SKILL.md).

## Default Workflow

### 1. Inventory the D1 surface

Start with the helper:

```bash
skills/cloudflare-d1-development/scripts/inspect-d1-development.sh \
  --repo /path/to/project
```

Use it to identify:

- `wrangler.jsonc` or `wrangler.toml`
- `d1_databases` declarations
- `preview_database_id` usage when relevant
- SQL migration or seed files
- D1-related code usage

### 2. Check the binding model

Explicitly verify:

- the D1 binding name used by the app
- whether it is declared in the right Wrangler scope
- whether local development should use local state or remote mode
- whether preview and production database expectations are documented

Do not assume the binding is correct just because the app compiles.

### 3. Check migrations and seed discipline

Look for:

- a `migrations/` directory or equivalent SQL workflow
- explicit seeding commands or seed files
- whether local databases can be recreated consistently
- whether the repo depends on one-off manual dashboard changes

If the workflow is implicit, call that out as a real risk.

### 4. Check app access patterns

Compare code usage against the actual D1 binding and schema workflow.

Flag cases where:

- code references a D1 binding that Wrangler does not declare
- schema files exist but are not obviously applied
- local-dev docs mention one workflow while scripts use another
- the app treats D1 as a generic env var instead of a runtime binding

### 5. Produce a development plan

Write a concise plan with:

- current D1 configuration
- local and preview behavior
- migration and seed status
- missing declarations or workflow gaps
- recommended next implementation step

Default output location:

```text
docs/cloudflare/YYYY-MM-DD-d1-development.md
```

## Output Contract

Minimum sections:

- summary
- current D1 binding model
- local and preview behavior
- migration and seed workflow
- code and config drift
- next steps

## Quick Reference

| Need | Action |
| --- | --- |
| inventory D1 setup | run the helper |
| check binding declarations | inspect Wrangler D1 config |
| validate dev workflow | review local vs remote mode, migrations, and seeds |
| compare app code with config | inspect D1 usage in source files |

## Common Mistakes

- assuming D1 config is correct because a binding exists somewhere
- skipping local migration and seed discipline
- mixing preview and production database expectations
- using remote D1 by default during local development without saying so
- treating D1 access as an env-var problem instead of a runtime binding problem
