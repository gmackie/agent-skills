---
name: maestro-qa-report
description: Use when a React Native or Expo app needs report-only mobile QA with Maestro on a simulator or emulator. Verifies local prerequisites, runs flows with explicit artifact and report output, captures screenshots and logs, classifies severity, and produces exact repro notes without making code changes.
---

# Maestro QA Report

## Overview

Run Maestro as a report-only QA pass.

This skill is for verifying behavior and documenting failures, not fixing them. Use it before a fix-capable QA skill, before release-readiness work, or when the user wants reproducible mobile QA evidence from a local simulator or emulator run.

## Default Workflow

### 1. Confirm the test surface

Before running anything, establish:

- target platform: iOS simulator or Android emulator
- app type: Expo or bare React Native
- app binary: development build, preview build, or simulator/emulator build
- flow location: usually `.maestro/` in the app repo

For Expo projects, prefer a development build or dedicated test build. Do not treat Expo Go as the default serious QA target.

### 2. Verify prerequisites

Check for:

- `maestro` installed
- a running simulator or emulator
- flow files present
- a stable output directory for artifacts

Use the bundled helper:

```bash
skills/maestro-qa-report/scripts/run-maestro-qa-report.sh \
  --repo /path/to/app \
  --flow-path .maestro \
  --output-dir build/maestro-results \
  --report-format html-detailed \
  --report-file build/maestro-report.html
```

If the repo uses tags, pass them through:

```bash
skills/maestro-qa-report/scripts/run-maestro-qa-report.sh \
  --repo /path/to/app \
  --flow-path .maestro \
  --include-tags smoke
```

### 3. Run flows and capture artifacts

Prefer:

- short smoke flows first
- explicit output paths
- HTML or HTML-detailed reports for human review
- a separate debug directory when logs matter

Current Maestro guidance supports:

- `--test-output-dir` for screenshots, videos, commands JSON, and related artifacts
- `--format junit|html|html-detailed`
- `--output` for report file paths

### 4. Turn failures into QA findings

For each verified failure, record:

- severity: `blocker`, `major`, `minor`, or `cosmetic`
- exact flow and step
- exact repro path
- expected vs actual behavior
- artifact links or paths
- suspected ownership: app code, test flow, seed data, environment, or backend dependency

Use the report template in [references/report-template.md](references/report-template.md).

### 5. Do not fix code in this skill

This is report-only.

Do not:

- edit app code
- rewrite flows unless the failure is clearly a broken test artifact and the user asked for that
- collapse environment failures and product bugs into one bucket

Escalate with a clean report instead.

## Severity Rules

| Severity | Meaning |
| --- | --- |
| `blocker` | cannot complete a critical user path or app cannot be meaningfully tested |
| `major` | core flow works poorly or fails in a release-significant way |
| `minor` | non-critical behavior is broken but core flow still works |
| `cosmetic` | copy, spacing, visual, or low-risk polish issue |

When uncertain, prefer `major` over `blocker` unless the app is unusable for the target flow.

## Quick Reference

| Need | Action |
| --- | --- |
| run local report-only QA | use the helper with explicit output paths |
| keep artifacts organized | set `--output-dir` and `--report-file` |
| narrow run scope | use `--include-tags` |
| debug environment issues | add `--debug-output-dir` |
| write the final summary | use the report template |

## Common Mistakes

- running against Expo Go when the issue depends on a real dev or preview build
- treating missing simulator setup as an app bug
- running a giant suite before proving one smoke flow works
- reporting a failure without artifact paths or exact flow steps
- fixing code during a report-only QA pass

## Example

If the user asks:

`run maestro qa and give me a report for the login and onboarding flows`

do this:

1. verify Maestro, device, and flow files
2. run the targeted flows with explicit report and artifact output paths
3. inspect the generated report plus screenshots and logs
4. write a concise QA report with severity, repro steps, and suspected ownership
5. stop at the report unless the user explicitly asks to fix issues
