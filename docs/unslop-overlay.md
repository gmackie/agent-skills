# Unslop overlay

Every installable `SKILL.md` passes the local `unslop` style check. The check covers all 82 skills, including the 50 pinned upstream imports.

Upstream imports keep their original repository, revision, path, and tree hash. Local prose edits are recorded with the import mode `vendored-with-frontmatter-metadata-and-unslop-overlay`, so the catalog does not imply that the checked-in body is byte-for-byte upstream text.

## Overlay rules

The current mechanical overlay is `unslop-punctuation-v1`:

- replace em dashes with sentence punctuation that preserves the clause relationship
- replace curly quotes with straight quotes
- keep commands, code, paths, trigger conditions, required actions, and decision rules unchanged
- review generated punctuation by hand before accepting the diff

The overlay may also use sentence-case headings or rewrite an inline bold label when the change cannot alter agent behavior. Any change to a trigger, workflow branch, safety rule, or completion condition needs a separate pressure test under the skill-authoring workflow.

`#` skill-title headings are exempt from sentence casing because they are canonical names and may contain proper nouns. The sentence-case check applies to `##` through `######` content headings.

## Verification

```bash
./tests/verify-unslop-style.sh
./tests/verify-unslop-overlay.sh
./tests/verify-unslop-tools.sh
./tests/verify-contract.sh
./tests/verify-new-public-skills.sh
./scripts/verify-installable-skills-config.sh
./tests/verify-skill-selection.sh
npx --yes skills add . --list
```

## Refreshing an upstream skill

1. Import the new pinned revision and record its source tree.
2. Reapply `scripts/unslop-punctuation.pl` to the refreshed `SKILL.md`.
3. Review every changed sentence against upstream for meaning drift.
4. Run the full verification list above.
