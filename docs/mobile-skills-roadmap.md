# Mobile Skills Roadmap

Snapshot date: 2026-03-26

This note captures the immediate direction for turning this repo into a stronger mobile-focused skills library, especially around React Native, Expo, Maestro, and App Store readiness.

## Current State

The repo already exposes installable skills through `skills/*/SKILL.md`, and `npx skills add . --list` currently detects 14 skills from this workspace.

The main gaps are not discovery. The gaps are depth, structure, and boundaries:

- Expo skills are broad and procedural, but not yet first-principles or up to date.
- There is no Maestro skill.
- There is no mobile QA workflow skill that separates report-only QA from fix-and-verify QA.
- App Store review knowledge exists on the machine as an installed skill, but not as part of this repo's mobile suite.
- The README still describes a Kiro-style library structure that does not match the current repo.
- Some skills use extra frontmatter fields like `allowed-tools` and `metadata`; `npx skills` tolerated them in listing, but the target format is a minimal `name` + `description` `SKILL.md`.

## Recommendation

Build the mobile layer as a suite, not a single giant skill.

Recommended split:

1. `mobile-maestro-qa`
2. `mobile-maestro-qa-report`
3. `expo-build-validation`
4. `expo-build-submit`
5. `app-store-review`
6. `react-native-expo-release-readiness`

This keeps triggering precise and lets an agent compose skills instead of loading one overloaded document.

## Skill Boundaries

### `mobile-maestro-qa`

Use when the user wants an agent to test a React Native or Expo app with Maestro and then fix verified issues.

Responsibilities:

- detect Expo vs bare React Native context
- verify Maestro prerequisites
- prefer stable selectors and accessibility labels
- run local Maestro flows against simulator or emulator
- capture repro steps, screenshots, and failing assertions
- map UI failures back to app code
- fix one bug at a time and rerun the failing flow
- produce a ship-readiness summary

Bundled resources:

- `references/selector-strategy.md`
- `references/expo-vs-bare.md`
- `scripts/run-local-maestro.sh`
- `scripts/collect-maestro-artifacts.sh`
- example flows in `assets/flows/`

### `mobile-maestro-qa-report`

Use when the user wants a QA report only.

Responsibilities:

- run flows
- gather screenshots and logs
- classify severity
- avoid code changes
- return exact repro steps and suspected ownership

This is the mobile analogue of `gstack`'s report-only QA shape.

### `react-native-expo-release-readiness`

Use when preparing a mobile app for internal release, TestFlight, Play internal testing, or store submission.

Responsibilities:

- run config and dependency checks
- verify build profile setup
- verify environment variables and update policy
- check permissions, icons, splash, app versioning, OTA risk, and review notes
- hand off to `app-store-review` for policy review

This is the orchestration skill. It should call into narrower skills conceptually instead of duplicating them.

## Maestro-Specific Guidance

Maestro is the right abstraction for black-box mobile QA because it works against visible UI and accessibility hooks instead of implementation details.

Practical rules for the skill:

- prefer `testID` plus accessible labels for stable selectors
- treat text-only selectors as fallback, not primary strategy
- keep flows task-focused and short
- add one smoke flow per critical surface before adding exhaustive flows
- separate environment bootstrapping from actual test logic
- store reusable subflows for login, onboarding dismissal, and seeded test data setup
- require artifact capture on every failure

## Expo / React Native Guidance

For Expo projects, the default target should be:

- local Maestro runs during development
- EAS Workflows Maestro runs on pull requests
- dedicated `e2e-test` build profile for simulator / emulator binaries

That matches current Expo guidance and prevents trying to run serious QA only through Expo Go.

## App Store Readiness Layer

The QA skill should not try to absorb App Store policy.

Keep App Store review as a separate skill because it answers a different question:

- Maestro QA asks: "Does the app work?"
- App Store review asks: "Will the app get rejected?"

For mobile shipping, the useful chain is:

1. `mobile-maestro-qa-report` or `mobile-maestro-qa`
2. `expo-build-validation`
3. `react-native-expo-release-readiness`
4. `app-store-review`
5. `expo-build-submit`

## Repo Alignment for `npx skills`

The repo is already close enough to be installable, but it should move toward the open skills format more explicitly.

Immediate changes:

- keep installable skills under `skills/<skill-name>/SKILL.md`
- keep frontmatter to `name` and `description`
- move heavy guidance into `references/`
- move reusable commands into `scripts/`
- add `agents/openai.yaml` only where UI metadata is actually needed
- treat `docs/` as repo guidance, not skill payload
- stop adding flat markdown "meta-skills" at `skills/*.md`

Recommended repo shape:

```text
agent-skills/
├── skills/
│   ├── expo-build-validation/
│   │   └── SKILL.md
│   ├── expo-build-submit/
│   │   └── SKILL.md
│   ├── mobile-maestro-qa/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   ├── scripts/
│   │   └── assets/
│   ├── mobile-maestro-qa-report/
│   │   └── SKILL.md
│   └── react-native-expo-release-readiness/
│       └── SKILL.md
├── docs/
│   ├── installed-global-skills.md
│   └── mobile-skills-roadmap.md
└── README.md
```

## Proposed Build Order

1. Refactor existing Expo skills down to minimal frontmatter and cleaner references.
2. Add `app-store-review` to this repo as a maintained dependency or forked local copy.
3. Create `mobile-maestro-qa-report` first.
4. Create `mobile-maestro-qa` second, reusing the same flow and artifact patterns.
5. Create `react-native-expo-release-readiness` last as the orchestration skill.

This order matters because report-only QA clarifies the failure taxonomy before we teach an agent to auto-fix.

## Notes from Current Research

Primary-source findings used for this roadmap:

- `npx skills` currently installs from GitHub repos, direct skill paths, and local paths, and identifies agent skills as `SKILL.md` files with YAML `name` and `description`.
- Expo documents first-party EAS Workflows support for Maestro jobs and shows a standard `.maestro/` plus `.eas/workflows/` setup with an `e2e-test` build profile.
- Apple's App Store Review Guidelines still emphasize crash-free behavior, complete metadata, valid review access, live backend services during review, and detailed review notes for non-obvious features.

## What To Do Next

Best next step: build `mobile-maestro-qa-report` first and keep it narrow.

If the first mobile QA skill is successful, then add:

- a fix-capable variant
- a release-readiness orchestrator
- a machine-generated inventory sync script for this repo's tracked install state
