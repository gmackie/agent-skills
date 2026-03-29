# D1 Development Checklist

Use this checklist when validating D1 setup in a Cloudflare Workers project.

## Configuration

- `d1_databases` declarations exist in Wrangler config
- the binding name matches what the app actually uses
- `preview_database_id` is set when the workflow needs it
- environment-specific D1 declarations are explicit when needed

## Development Workflow

- local development mode is clear: local or remote
- migration files exist and are tracked
- seed workflow exists or its absence is intentional
- local database recreation is reproducible

## App Access

- code accesses D1 through the runtime binding model
- source files do not rely on imaginary env-only database access
- docs, scripts, and config agree on how the database is used

## Rollout

- preview and production database expectations are documented
- the next migration or config step is explicit
