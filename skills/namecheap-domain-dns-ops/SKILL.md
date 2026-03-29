---
name: namecheap-domain-dns-ops
description: Use when planning or reviewing domain and DNS operations for domains registered at Namecheap. Inventories domain, nameserver, and host-record signals in a repo, checks whether the workflow belongs in Namecheap or a third-party DNS provider, and produces a concrete DNS operations plan instead of ad hoc panel clicking.
---

# Namecheap Domain DNS Ops

## Overview

Use this skill when a project depends on domains registered at Namecheap and the problem is DNS or cutover operations, not generic branding or naming.

This skill focuses on:

- whether DNS is actually managed in Namecheap
- host-record versus nameserver changes
- repo-visible domain and verification needs
- cutover and drift risks

## Default Workflow

### 1. Inventory the domain surface

Start with the helper:

```bash
skills/namecheap-domain-dns-ops/scripts/inspect-domain-dns-surface.sh \
  --repo /path/to/project
```

Use it to identify:

- domain names mentioned in env files, docs, or config
- DNS-provider markers
- common verification and record patterns like A, CNAME, TXT, MX, CAA

### 2. Check whether Namecheap is the real DNS control plane

Before planning record work, verify:

- whether the domain uses Namecheap BasicDNS, FreeDNS, or PremiumDNS
- or whether the domain is delegated to custom nameservers and DNS must be changed elsewhere

Do not assume “registered at Namecheap” means “DNS managed at Namecheap.”

### 3. Review record and cutover intent

Explicitly identify:

- apex/root-domain needs
- `www` and subdomain routing
- email or verification records
- certificate or CAA needs
- whether a nameserver change would wipe assumptions about host records

### 4. Produce a DNS ops plan

Write a concise plan with:

- current domain and DNS surface
- whether Namecheap is the right place to make changes
- missing records or cutover risks
- recommended next step

Default output location:

```text
docs/infrastructure/YYYY-MM-DD-namecheap-dns-ops.md
```

## Output Contract

Minimum sections:

- summary
- current domain surface
- DNS control-plane review
- record and cutover review
- next steps

## Common Mistakes

- editing Namecheap host records when the domain uses custom nameservers
- planning CNAME usage at the apex without checking the provider model
- changing nameservers without recreating required records on the new DNS provider
- mixing registrar tasks with DNS-hosting tasks
