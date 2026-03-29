---
name: react-native-expo-release-readiness
description: Use when preparing a React Native or Expo app for internal release, TestFlight, Play internal testing, or store submission. Discovers the project’s release surface, sequences Maestro QA, Expo validation, versioning, environment, OTA, and review-note checks, then hands off to narrower skills for fixes, App Store review, and submission.
---

# React Native Expo Release Readiness

## Overview

Use this skill to orchestrate release readiness across mobile QA, Expo build checks, and submission preparation.

This is not the place to do every deep check inline. Its job is to map the release surface, decide what still needs proof, and route work into narrower skills:

- [maestro-qa-report](../maestro-qa-report/SKILL.md)
- [maestro-qa](../maestro-qa/SKILL.md)
- [expo-build-validation](../expo-build-validation/SKILL.md)
- [expo-build-submit](../expo-build-submit/SKILL.md)
- `app-store-review` when iOS policy review matters

## Default Workflow

### 1. Discover the release surface

Start by identifying:

- app type: Expo managed, Expo prebuild, or bare React Native
- release target: internal testing, TestFlight, Play internal, App Store, or Play production
- build system: EAS Build / EAS Submit vs custom native pipeline
- QA surface: local Maestro flows, EAS workflow Maestro jobs, or both

Use the bundled helper:

```bash
skills/react-native-expo-release-readiness/scripts/plan-release-readiness.sh \
  --repo /path/to/app
```

Treat the helper output as the starting inventory, not the final decision.

### 2. Prove the app works before submission work

If the app has not been recently verified:

- use `maestro-qa-report` for a report-only pass
- use `maestro-qa` if the user wants issues fixed and rerun

Do not jump straight to submission tasks when critical user paths are unverified.

### 3. Validate build and configuration readiness

Run the Expo validation layer for:

- config integrity
- dependency compatibility
- icon and splash assets
- bundle identifiers and package names
- EAS profile presence

Focus specifically on:

- `app.json` or `app.config.*`
- `eas.json`
- version/build number strategy
- runtime version / update policy when OTA updates are enabled
- environment variable handling for release builds

### 4. Check release-significant gaps

Before submission or handoff, explicitly confirm:

- permissions and purpose strings are accurate
- review credentials or demo accounts exist when needed
- release notes and review notes are ready
- OTA updates are not hiding major feature changes
- internal/test builds use the right profile and binary type

For iOS, remember that shipping to App Store Connect or TestFlight is not the same as being ready for App Review.

### 5. Route into the submission and policy layer

When the app is technically ready:

- use `app-store-review` for iOS review risk
- use `expo-build-submit` for actual store upload mechanics

Keep these separate:

- product behavior QA
- technical build readiness
- policy or review readiness
- submission execution

## Output Contract

Write a concise readiness summary using [references/readiness-template.md](references/readiness-template.md).

Minimum sections:

- target release surface
- discovered project shape
- completed checks
- blocking gaps
- recommended next skills

Default write location:

```text
docs/release-readiness/YYYY-MM-DD-<target>.md
```

## Quick Reference

| Need | Action |
| --- | --- |
| understand the repo surface fast | run the helper |
| prove behavior first | use `maestro-qa-report` or `maestro-qa` |
| validate Expo config | use `expo-build-validation` |
| review iOS submission risk | use `app-store-review` |
| upload once ready | use `expo-build-submit` |

## Common Mistakes

- treating TestFlight upload as the same thing as App Review readiness
- skipping Maestro or manual QA because the build succeeds
- ignoring version/build-number drift across iOS and Android
- shipping OTA-sensitive changes without checking update policy
- mixing technical readiness with policy review and submission mechanics

## Example

If the user asks:

`get this expo app ready for testflight and app review`

do this:

1. map the repo shape and release target
2. prove the main flows work with Maestro
3. validate Expo config and build profiles
4. collect review credentials, notes, permissions, and versioning gaps
5. route into `app-store-review`
6. only then hand off to `expo-build-submit`
