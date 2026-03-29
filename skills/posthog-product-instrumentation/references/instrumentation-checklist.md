# PostHog Instrumentation Checklist

## Setup

- PostHog package is present
- initialization path is visible
- API key and host configuration are explicit

## Product Instrumentation

- event names are intentional
- identify and group usage are coherent
- noisy or duplicate capture is limited

## Feature Flags

- feature flags are used for real rollout risk
- evaluation location is intentional
- stale or temporary flags are visible as cleanup work

## Rollout

- the next instrumentation step is explicit
- product questions are tied to actual events or flags
