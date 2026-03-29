---
name: hetzner-cloud-ops
description: Use when provisioning, reviewing, or hardening infrastructure that runs on Hetzner Cloud. Inventories hcloud, Terraform, cloud-init, and service bootstrap signals in the repo, then writes an operations plan for server lifecycle, networking, bootstrap, and drift instead of treating Hetzner as an opaque VPS host.
---

# Hetzner Cloud Ops

## Overview

Use this skill when the project depends on Hetzner Cloud and the task is server or environment operations, not generic Linux debugging.

This skill focuses on:

- Hetzner Cloud provisioning signals
- bootstrap and cloud-init discipline
- networking and firewall assumptions
- drift between declared infra and actual service setup

## Default Workflow

### 1. Inventory the Hetzner surface

Start with the helper:

```bash
skills/hetzner-cloud-ops/scripts/inspect-hetzner-surface.sh \
  --repo /path/to/project
```

Use it to identify:

- `hcloud` CLI usage
- Terraform provider usage
- cloud-init or user-data files
- Docker Compose, Caddy, Traefik, or service bootstrap markers

### 2. Check the provisioning model

Explicitly review:

- whether the repo provisions through Terraform, the CLI, or ad hoc dashboard work
- whether server creation and bootstrap are reproducible
- whether networking and firewall assumptions are visible

### 3. Check lifecycle and drift risks

Flag cases where:

- cloud-init exists but is not clearly used
- servers are expected to be hand-configured
- secrets, IPs, or hostnames are hardcoded in brittle places
- repo docs and bootstrap scripts disagree

### 4. Produce an ops plan

Write a concise plan with:

- current Hetzner surface
- reproducibility gaps
- networking and bootstrap risks
- recommended next implementation or cleanup step

Default output location:

```text
docs/infrastructure/YYYY-MM-DD-hetzner-cloud-ops.md
```

## Output Contract

Minimum sections:

- summary
- current provisioning model
- bootstrap and networking review
- drift risks
- next steps
