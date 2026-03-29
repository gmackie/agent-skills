# Hetzner Cloud Ops Checklist

## Provisioning

- Hetzner usage is visible through `hcloud`, Terraform, or both
- server creation is reproducible
- bootstrap path is documented

## Networking

- firewall and network assumptions are explicit
- hostnames, floating IPs, and service exposure are intentional

## Bootstrap

- cloud-init or equivalent exists when needed
- bootstrap is not dependent on undocumented manual steps

## Rollout

- drift between docs, scripts, and infra is called out
- the next ops step is explicit
