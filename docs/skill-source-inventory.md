# Skill Source Inventory

Snapshot date: 2026-08-13

This note tracks outside skill sources and related repos worth reviewing for possible import, adaptation, or inspiration. It is intentionally lightweight and grouped into:

- public candidates
- private candidates
- not-found-yet gaps

## Public Candidates

## Imported and pinned

The exact machine-readable inventory lives in
[`catalog/upstream-sources.json`](../catalog/upstream-sources.json). The current
curated import includes selected high-fit skills from:

- [Cursor pstack](https://github.com/cursor/plugins/tree/195d9359bdc2890f83745df69927528ad4538406/pstack)
- [Matt Pocock's skills](https://github.com/mattpocock/skills/tree/84fdeffd12f2ee307994d1eb6feb48173b6e0502)
- [Dillon Mulroy's anti-slop](https://github.com/dmmulroy/anti-slop/tree/9b80d9a5c317d3af94d88a577bdbde4d9a45f7be)

These are vendored copies, not floating dependencies. The current curated
seed set imports 50 of the 80 upstream skill folders available at the pinned
revisions: 30 from Cursor pstack, 19 from Matt Pocock's skills, and 1 from
dmmulroy anti-slop. Updating one requires a new pinned revision, a reviewed
diff, refreshed provenance, and catalog tests.

Cursor pstack skills that depend on Cursor-shaped subagent orchestration,
`.cursor` configuration, or Cursor skill-management paths are marked
`supportedAgents: ["cursor"]` in `catalog/upstream-sources.json` and
`skill.json`. Portable pstack principles and Matt Pocock workflow skills are
marked for Codex, Claude Code, Cursor, and Grok.

### Cloudflare

- `cloudflare-troubleshooting`
  Source: [daymade/claude-code-skills](https://github.com/daymade/claude-code-skills)
  Why look: Cloudflare diagnostics and troubleshooting workflow.

- `cloudflare`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: Cloudflare CLI workflow for DNS, cache, and Workers routes.

- `cloudflare-2`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: Cloudflare API workflow for DNS, tunnels, and zone administration.

- `send-me-my-files-r2-upload-with-short-lived-signed-urls`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: R2 and signed URL flow patterns.

### vinext

- `migrate-to-vinext`
  Source: local skill at [migrate-to-vinext](../skills/migrate-to-vinext/SKILL.md)
  Why look: already the strongest concrete vinext skill in hand.

### Namecheap

- `namecheap-domains`
  Source: `clasen/skills@namecheap-domains` via `npx skills find namecheap`
  Why look: direct Namecheap-specific skill hit from the public skills ecosystem.

- `domain-dns-ops`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: explicitly spans Cloudflare, DNSimple, and Namecheap.

- `premium-domains`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: adjacent domain acquisition and registrar workflow.

### Hetzner

- `hetzner-server`
  Source: `connorads/dotfiles@hetzner-server` via `npx skills find hetzner`
  Why look: strongest discoverable public Hetzner hit in the current registry.

- `hetzner-cloud`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: Hetzner Cloud CLI management workflow.

### Stripe

- `stripe-payments-integration`
  Source: local skill at [stripe-payments-integration](../skills/stripe-payments-integration/SKILL.md)
  Why look: already relevant and maintained here.

- `stripe`
  Source: [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)
  Why look: external reference point for payment workflow coverage.

## Private Candidates

These look better as app- or org-specific skills than public imports.

### ControlsFoundry

- `controlsfoundry-release-loop`
- `controlsfoundry-cloudflare-stack`

### Level Forge

- `levelforge-content-release`

### ForgeGraph

- `forgegraph-worker-ops`

## Not Found Yet

These areas did not produce a strong public skill candidate in this pass.

### Sentry

- `getsentry/skills@security-review`
  Source: `npx skills find sentry`
  Why look: strong public Sentry-maintained ecosystem presence, even if security-focused rather than release-triage focused.

- `getsentry/sentry-agent-skills@sentry-fix-issues`
  Source: `npx skills find sentry`
  Why look: direct Sentry-maintained issue workflow worth compositional review.

- Local composite skill now added:
  [sentry-release-triage](../skills/sentry-release-triage/SKILL.md)

### PostHog

- `posthog/posthog-for-claude@posthog-instrumentation`
  Source: `npx skills find posthog`
  Why look: direct PostHog-owned instrumentation skill in the public registry.

- `alinaqi/claude-bootstrap@posthog-analytics`
  Source: `npx skills find posthog`
  Why look: adjacent public analytics workflow reference.

- Local composite skill now added:
  [posthog-product-instrumentation](../skills/posthog-product-instrumentation/SKILL.md)

### QuickBooks

- no strong public skill source identified yet

### dmmulroy anti-slop

- `install-anti-slop`
  Source: [dmmulroy/anti-slop](https://github.com/dmmulroy/anti-slop/tree/9b80d9a5c317d3af94d88a577bdbde4d9a45f7be)
  Why look: direct anti-slop Oxlint workflow and the only skill folder in the
  pinned repo.

## Local Composite Skills Added

- [sentry-release-triage](../skills/sentry-release-triage/SKILL.md)
- [posthog-product-instrumentation](../skills/posthog-product-instrumentation/SKILL.md)
- [hetzner-cloud-ops](../skills/hetzner-cloud-ops/SKILL.md)
- [namecheap-domain-dns-ops](../skills/namecheap-domain-dns-ops/SKILL.md)

## Best Immediate Review Order

1. [sentry-release-triage](../skills/sentry-release-triage/SKILL.md)
2. [posthog-product-instrumentation](../skills/posthog-product-instrumentation/SKILL.md)
3. [hetzner-cloud-ops](../skills/hetzner-cloud-ops/SKILL.md)
4. [namecheap-domain-dns-ops](../skills/namecheap-domain-dns-ops/SKILL.md)
5. [daymade/claude-code-skills](https://github.com/daymade/claude-code-skills)
6. [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)

## Adjacent Internal Docs

- [cloudflare-next-skill-opportunities.md](cloudflare-next-skill-opportunities.md)
