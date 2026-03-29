# Sentry Release Triage Checklist

## SDK Surface

- Sentry package is present
- runtime initialization path is visible
- framework-specific config files are present when expected

## Release Hygiene

- release naming is intentional
- environment naming is intentional
- source maps are uploaded before errors occur in that release

## Coverage

- browser, server, worker, or native coverage boundaries are explicit
- obvious critical paths have error capture
- integration is not limited to scattered ad hoc calls

## Rollout

- blocking gaps are named clearly
- the next verification or implementation step is explicit
