---
name: posthog-product-instrumentation
description: Use when a web app or product surface needs PostHog instrumentation reviewed or added with discipline. Inventories SDK setup, provider wiring, event capture calls, identify/group usage, and feature-flag boundaries, then produces a concrete instrumentation plan instead of ad hoc analytics sprawl.
---

# PostHog Product Instrumentation

## Overview

Use this skill when the question is how a product should be instrumented with PostHog, not whether analytics exist at all.

This skill focuses on:

- SDK and provider setup
- event capture and identify usage
- feature-flag boundaries
- gaps between product intent and what is actually instrumented

## Default Workflow

### 1. Inventory the PostHog surface

Start with the helper:

```bash
skills/posthog-product-instrumentation/scripts/inspect-posthog-surface.sh \
  --repo /path/to/project
```

Use it to identify:

- PostHog packages
- provider and init files
- event capture, identify, group, and feature-flag usage
- env vars or host keys

### 2. Check whether the instrumentation boundary is coherent

Explicitly review:

- where PostHog is initialized
- whether user identification is intentional
- whether feature flags are evaluated in the right place
- whether the repo captures meaningful product events or just pageviews and noise

### 3. Review rollout and flag discipline

Flag cases where:

- feature flags are sprinkled through the app without rollout intent
- events are named inconsistently
- capture calls exist without clear product semantics
- user or group identity is ambiguous

### 4. Produce an instrumentation plan

Write a concise plan with:

- current instrumentation surface
- event and identity gaps
- feature-flag risks
- recommended next implementation step

Default output location:

```text
docs/observability/YYYY-MM-DD-posthog-instrumentation.md
```

## Output Contract

Minimum sections:

- summary
- current PostHog surface
- event and identity review
- feature-flag review
- blocking gaps
- next steps

## Common Mistakes

- adding events without a naming strategy
- overusing feature flags for low-value paths
- evaluating flags in the wrong layer and causing flicker or drift
- capturing lots of data without tying it to product decisions
