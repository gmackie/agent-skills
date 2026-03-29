---
name: sentry-release-triage
description: Use when a web app or service has Sentry installed and the task is to verify release readiness, source map correctness, environment wiring, or basic issue-triage hygiene before or after shipping. Inventories SDK setup, config files, release markers, and error-boundary coverage, then writes a focused triage plan.
---

# Sentry Release Triage

## Overview

Use this skill when the repo already uses Sentry or is clearly intended to, and the immediate problem is release hygiene rather than a full observability redesign.

This skill focuses on:

- SDK presence and config shape
- release and environment wiring
- source map upload assumptions
- obvious client and server coverage gaps

It is not a general logging or incident-response skill.

## Default Workflow

### 1. Inventory the Sentry surface

Start with the helper:

```bash
skills/sentry-release-triage/scripts/inspect-sentry-surface.sh \
  --repo /path/to/project
```

Use it to identify:

- Sentry packages
- `sentry.*.config.*` files
- env vars like DSNs, auth tokens, and environment markers
- release and source-map-related code or CI hooks

### 2. Check whether release triage actually applies

Verify that the repo is using Sentry or intends to:

- SDK package present
- config files present
- or clear code markers like `Sentry.init`, `captureException`, `ErrorBoundary`, or framework setup files

If none of those exist, stop and say the skill does not apply cleanly yet.

### 3. Review release hygiene

Explicitly check:

- whether release names are set intentionally
- whether environment tags are distinguishable
- whether source maps are generated and uploaded before errors happen in that release
- whether client, server, or edge/runtime coverage is obviously partial

Do not treat “Sentry installed” as equivalent to “Sentry usable.”

### 4. Review app integration drift

Flag cases where:

- config files exist but no clear runtime initialization path is visible
- source-map upload is implied but not wired
- DSN or auth-token env vars are missing or inconsistently named
- the app captures errors ad hoc but lacks coherent release coverage

### 5. Produce a triage plan

Write a concise plan with:

- current integration shape
- release and source-map risks
- environment and coverage gaps
- recommended next implementation or verification step

Default output location:

```text
docs/observability/YYYY-MM-DD-sentry-release-triage.md
```

## Output Contract

Minimum sections:

- summary
- current Sentry surface
- release and environment review
- source-map and coverage review
- blocking gaps
- next steps

## Common Mistakes

- assuming source maps work because the SDK is installed
- collapsing all environments into one noisy Sentry project shape
- shipping without explicit release naming
- treating sporadic `captureException` calls as full integration
