# Skill Source Inventory

Snapshot date: 2026-03-28

This note tracks outside skill sources and related repos worth reviewing for possible import, adaptation, or inspiration. It is intentionally lightweight and grouped into:

- public candidates
- private candidates
- not-found-yet gaps

## Public Candidates

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
  Source: local skill at [migrate-to-vinext](/Volumes/dev/agent-skills/skills/migrate-to-vinext/SKILL.md)
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
  Source: local skill at [stripe-payments-integration](/Volumes/dev/agent-skills/skills/stripe-payments-integration/SKILL.md)
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
  [sentry-release-triage](/Volumes/dev/agent-skills/skills/sentry-release-triage/SKILL.md)

### PostHog

- `posthog/posthog-for-claude@posthog-instrumentation`
  Source: `npx skills find posthog`
  Why look: direct PostHog-owned instrumentation skill in the public registry.

- `alinaqi/claude-bootstrap@posthog-analytics`
  Source: `npx skills find posthog`
  Why look: adjacent public analytics workflow reference.

- Local composite skill now added:
  [posthog-product-instrumentation](/Volumes/dev/agent-skills/skills/posthog-product-instrumentation/SKILL.md)

### QuickBooks

- no strong public skill source identified yet

### Dylan Milroy

- no clear primary-source repo or skill collection identified in this pass
- if there is a specific repo to mine, add it here explicitly next round

## Local Composite Skills Added

- [sentry-release-triage](/Volumes/dev/agent-skills/skills/sentry-release-triage/SKILL.md)
- [posthog-product-instrumentation](/Volumes/dev/agent-skills/skills/posthog-product-instrumentation/SKILL.md)
- [hetzner-cloud-ops](/Volumes/dev/agent-skills/skills/hetzner-cloud-ops/SKILL.md)
- [namecheap-domain-dns-ops](/Volumes/dev/agent-skills/skills/namecheap-domain-dns-ops/SKILL.md)

## Best Immediate Review Order

1. [sentry-release-triage](/Volumes/dev/agent-skills/skills/sentry-release-triage/SKILL.md)
2. [posthog-product-instrumentation](/Volumes/dev/agent-skills/skills/posthog-product-instrumentation/SKILL.md)
3. [hetzner-cloud-ops](/Volumes/dev/agent-skills/skills/hetzner-cloud-ops/SKILL.md)
4. [namecheap-domain-dns-ops](/Volumes/dev/agent-skills/skills/namecheap-domain-dns-ops/SKILL.md)
5. [daymade/claude-code-skills](https://github.com/daymade/claude-code-skills)
6. [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills)

## Adjacent Internal Docs

- [cloudflare-next-skill-opportunities.md](/Volumes/dev/agent-skills/docs/cloudflare-next-skill-opportunities.md)
