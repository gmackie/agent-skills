# Workflow stack imports

The catalog includes Theo Browne’s complete [tstack](https://github.com/t3dotgg/tstack) and Lauren Tan’s complete official [pstack](https://github.com/cursor/plugins/tree/main/pstack). Exact revisions, skill paths, tree hashes, and licenses live in [upstream-sources.json](../catalog/upstream-sources.json).

The tstack collection has 9 skills for PR delivery and review. It supports Codex and Claude Code, requires authenticated `gh`, and uses `python3` for the PR helper. `council` and `sol-loop` also require access to other providers’ models through the harness. Installing those skills does not select models or start delegates.

The pstack collection has 58 skills, including 24 principles and 23 playbooks under `poteto-mode`. Its workflow metadata retains Cursor compatibility; the portable principles and existing cross-agent skills retain their supported agents. Cursor workflows that name `poteto-agent` or `comment-sicko` require the official pstack plugin to register those native agent types. Cursor-only services and external `cursor-team-kit` skills remain upstream prerequisites. Skillfleet catalog publication does not register plugins, agents, or automations. Claude Code users can install the official plugin through `cursor/plugins`; its generated Claude adapter is separate from these original Cursor payloads.

All supporting files inside each skill directory are copied, including executable helpers, references, playbooks, and OpenAI agent metadata. Markdown links outside the installed skills tree point to the pinned upstream revision. Sibling skill links stay local, so install the whole collection when using its router. Local frontmatter records tags, invocation, and provenance, and the repository’s mechanical unslop overlay remains applied. Existing group activation and skill IDs stay intact; new entries live in manual groups. Skillfleet’s `tstack` and `pstack` config profiles select each complete collection.

## Refresh the collections

Update the two source pins and expected skill counts in the provenance manifest, then check out those exact commits in clean source clones. Run:

```bash
python3 scripts/import-workflow-stacks.py --tstack /path/to/tstack --pstack /path/to/cursor-plugins
python3 tests/verify-workflow-stacks.py
./tests/verify-skill-selection.sh
./tests/verify-unslop-style.sh
./tests/verify-unslop-overlay.sh
./scripts/verify-installable-skills-config.sh
npx --yes skills add . --list
```

The importer rejects a checkout at a different revision, modified upstream files, source collisions, symbolic links, and removed upstream skills. It preserves existing selection groups and regenerates the smol-agent catalog. Review changed instructions and update the pinned expectations and notices before publishing.
