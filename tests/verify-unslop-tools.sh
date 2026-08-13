#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_dir="$(mktemp -d)"
trap 'rm -rf "$fixture_dir"' EXIT
mkdir -p "$fixture_dir/skills/tool-fixture"

cat > "$fixture_dir/skills/tool-fixture/SKILL.md" <<'FIXTURE'
# Tool Fixture

## API Surface and shadcn/ui

Prose — with “quotes”.

Inline code stays exact: `.husky/pre-commit — “quoted”`.

Mixed spans — ``code ``` content`` middle — “quote” and `x` tail.

## API Surface with ``literal ` husky`` and shadcn/ui

## API Surface with ``code ``` husky`` and shadcn/ui

## AI-Assisted Workflow

## 4. AI-Assisted Workflow

```bash
printf 'fenced — “quoted”\n'
```

````markdown
## Fenced Title Must Stay
literal ``` inside fence
code — “quoted”
```
still code — “quoted”
````
FIXTURE

perl "$repo_root/scripts/unslop-punctuation.pl" "$fixture_dir/skills/tool-fixture/SKILL.md" > "$fixture_dir/punctuated.md"

rg -F 'Prose, with "quotes".' "$fixture_dir/punctuated.md" >/dev/null
rg -F '`.husky/pre-commit — “quoted”`' "$fixture_dir/punctuated.md" >/dev/null
rg -F 'Mixed spans, ``code ``` content`` middle, "quote" and `x` tail.' "$fixture_dir/punctuated.md" >/dev/null
rg -F "printf 'fenced — “quoted”\\n'" "$fixture_dir/punctuated.md" >/dev/null
rg -F 'still code — “quoted”' "$fixture_dir/punctuated.md" >/dev/null

node "$repo_root/scripts/unslop-headings.mjs" "$fixture_dir" >/dev/null

rg -F '# Tool Fixture' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## API surface and shadcn/ui' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## API surface with ``literal ` husky`` and shadcn/ui' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## API surface with ``code ``` husky`` and shadcn/ui' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## AI-assisted workflow' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## 4. AI-assisted workflow' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '## Fenced Title Must Stay' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null
rg -F '`.husky/pre-commit — “quoted”`' "$fixture_dir/skills/tool-fixture/SKILL.md" >/dev/null

mkdir -p "$fixture_dir/skills/title-case-fixture"
cat > "$fixture_dir/skills/title-case-fixture/SKILL.md" <<'FIXTURE'
# Canonical Skill Title

## How to Use This Skill
FIXTURE

if bash "$repo_root/tests/verify-unslop-style.sh" "$fixture_dir" >/dev/null 2>&1; then
  printf 'Style checker accepted a mixed title-case content heading.\n' >&2
  exit 1
fi

printf 'Unslop helpers preserve fenced code, inline code, and exact identifiers.\n'
