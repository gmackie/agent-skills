# vinext Cloudflare Hardening Checklist

Use this checklist when reviewing a vinext project before a real Cloudflare deployment.

## Project State

- `vinext` is already installed and in active use
- `vite.config.*` exists
- deployment scripts reflect vinext rather than legacy Next.js commands

## Cloudflare Config

- Wrangler config exists and is the actual deployment source of truth
- assets binding is present when the app needs Worker-served assets
- image handling expectations are explicit
- environment and secret handling are mapped to the Worker runtime

## Cache and Persistence

- cache strategy is explicit
- KV-backed cache is configured when persistence across invocations matters
- related bindings exist for any cache handler the app expects

## Rollout

- preview and production config drift is called out
- bundle-size and dependency-risk concerns are visible
- the next hardening step is explicit
