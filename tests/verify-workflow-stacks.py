#!/usr/bin/env python3
"""Check collection completeness, provenance, compatibility and helper payloads."""

import json
import re
from pathlib import Path


root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / "catalog/upstream-sources.json").read_text())
catalog = json.loads((root / "catalog/installable-skills.json").read_text())
listed = [skill_id for group in catalog["groups"] for skill_id in group["skillIds"]]
tstack_ids = {
    "babysit-pr", "council", "file-pr", "full-send", "full-stop",
    "leaving-pr-comments", "modernize", "sol-loop", "takeover",
}
for source_id in ("theo-tstack", "cursor-pstack"):
    source = manifest["sources"][source_id]
    imports = [item for item in manifest["imports"] if item["sourceId"] == source_id]
    ids = {item["skillId"] for item in imports}
    assert len(imports) == len(ids) == source["skillCount"], source_id
    assert re.fullmatch("[0-9a-f]{40}", source["revision"]), source_id
    assert (root / source["licenseFile"]).stat().st_size > 0, source_id
    if source_id == "theo-tstack":
        assert ids == tstack_ids
    else:
        assert {"poteto-mode", "poteto-help", "setup-pstack", "statechart", "no-comments", "swarm", "teach"} <= ids
        assert len([skill_id for skill_id in ids if skill_id.startswith("principle-")]) == 24
    for item in imports:
        skill_id = item["skillId"]
        directory = root / "skills" / skill_id
        metadata = json.loads((directory / "skill.json").read_text())
        assert listed.count(skill_id) == 1, skill_id
        assert metadata["id"] == skill_id
        assert metadata["provenance"]["sourceRevision"] == source["revision"], skill_id
        assert metadata["provenance"]["sourceTree"] == item["sourceTree"], skill_id
        assert metadata["supportedAgents"] == item["supportedAgents"], skill_id
        assert all(not path.is_symlink() for path in directory.rglob("*")), skill_id
        if source_id == "theo-tstack":
            assert metadata["supportedAgents"] == ["codex", "claude-code"], skill_id
        markdown = (directory / "SKILL.md").read_text()
        assert '\\"' not in markdown.split("---", 2)[1].split("license:")[0], skill_id
        assert f"{source['repository']}@{source['revision']}:{item['sourcePath']}" in markdown, skill_id
        assert "disable-model-invocation:" not in markdown.split("---", 2)[1], skill_id

assert json.loads((root / "skills/poteto-mode/skill.json").read_text())["supportedAgents"] == ["cursor"]
assert len(list((root / "skills/poteto-mode/playbooks").glob("*.md"))) == 23
for path in (
    "babysit-pr/scripts/pr-wait",
    "full-send/agents/openai.yaml",
    "poteto-mode/scripts/check-plan.mjs",
    "poteto-mode/scripts/watch-pr/watch-pr",
    "poteto-help/references/prompting.md",
    "statechart/scripts/statechart",
    "show-me-your-work/scripts/log.sh",
):
    assert (root / "skills" / path).is_file(), path
help_text = (root / "skills/poteto-help/SKILL.md").read_text()
assert "](../../docs/" not in help_text
assert f"/blob/{manifest['sources']['cursor-pstack']['revision']}/pstack/docs/" in help_text
print("Workflow stacks verified: 9 tstack skills, 58 pstack skills, 23 playbooks.")
