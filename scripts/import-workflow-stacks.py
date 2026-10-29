#!/usr/bin/env python3
"""Refresh the pinned tstack and pstack skill payloads from clean checkouts."""

import argparse
import json
import re
import shutil
import subprocess
from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parent.parent
MODE = "vendored-with-frontmatter-metadata-and-unslop-overlay"
PORTABLE_AGENTS = ["codex", "claude-code", "cursor", "grok"]


def git(root, *arguments):
    return subprocess.check_output(["git", "-C", str(root), *arguments], text=True).strip()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n")


def description(frontmatter):
    lines = frontmatter.splitlines()
    index = next(i for i, line in enumerate(lines) if line.startswith("description:"))
    value = lines[index].split(":", 1)[1].strip()
    if value in (">", ">-", "|", "|-"):
        parts = []
        for line in lines[index + 1:]:
            if line and not line.startswith((" ", "\t")):
                break
            parts.append(line.strip())
        return " ".join(parts).strip()
    if value.startswith('"'):
        return json.loads(value)
    if value.startswith("'"):
        return value[1:-1].replace("''", "'")
    return value


def pin_external_links(text, upstream_file, source_root, source):
    # A deployed skill has no catalog README/docs at ../../. Keep sibling
    # skills local; resolve references outside skills to the reviewed upstream.
    def replace(match):
        target = match.group(1)
        relative_path, separator, fragment = target.partition("#")
        resolved = (upstream_file.parent / relative_path).resolve()
        if not resolved.is_relative_to(source_root) or not resolved.exists():
            return match.group(0)
        path = resolved.relative_to(source_root)
        if path.parts[0] == "skills":
            return match.group(0)
        pinned_path = (Path(source["subdirectory"]) / path).as_posix()
        url = f"{source['repository']}/blob/{source['revision']}/{quote(pinned_path)}"
        return f"]({url}{separator}{fragment})"

    return re.sub(r"\]\((\.\./[^\s)]+)\)", replace, text)


def import_stack(source_id, checkout, manifest, catalog):
    source = manifest["sources"][source_id]
    if git(checkout, "rev-parse", "HEAD") != source["revision"]:
        raise SystemExit(f"{source_id}: checkout does not match the pinned revision")
    if git(checkout, "status", "--porcelain", "--untracked-files=all"):
        raise SystemExit(f"{source_id}: checkout must be clean")
    source_root = checkout / source["subdirectory"]
    source_skills = sorted((source_root / "skills").glob("*/SKILL.md"))
    if len(source_skills) != source["skillCount"]:
        raise SystemExit(f"{source_id}: expected {source['skillCount']} upstream skills")

    collection = "tstack" if source_id == "theo-tstack" else "pstack"
    existing_imports = {item["skillId"]: item for item in manifest["imports"]}
    groups = {group["name"]: group for group in catalog["groups"]}
    assigned = {skill_id for group in groups.values() for skill_id in group["skillIds"]}
    imports = []
    for upstream_file in source_skills:
        skill_id = upstream_file.parent.name
        destination = ROOT / "skills" / skill_id
        previous = {}
        if (destination / "skill.json").exists():
            previous = json.loads((destination / "skill.json").read_text())
            if previous.get("provenance", {}).get("sourceId") != source_id:
                raise SystemExit(f"{skill_id}: refusing to replace a different source")
        for path in upstream_file.parent.rglob("*"):
            if path.is_symlink():
                raise SystemExit(f"{skill_id}: upstream symlink is not a portable payload")
        if destination.exists():
            shutil.rmtree(destination)
        shutil.copytree(upstream_file.parent, destination)

        group_ids = previous.get("groupIds", [collection])
        tags = sorted(set(previous.get("tags", ["workflow"]) + [collection]))
        portable = skill_id.startswith("principle-") or skill_id in {
            "unslop", "tdd", "typescript-best-practices", "technical-writing",
        }
        agents = (["codex", "claude-code"] if collection == "tstack"
                  else PORTABLE_AGENTS if portable
                  else previous.get("supportedAgents", ["cursor"]))
        invocation = previous.get("invocation", "model" if skill_id == "leaving-pr-comments" else "user")
        source_path = upstream_file.parent.relative_to(checkout).as_posix()
        tree = git(checkout, "rev-parse", f"{source['revision']}:{source_path}")
        provenance = {
            "sourceId": source_id,
            "sourceRepository": source["repository"],
            "sourceRevision": source["revision"],
            "sourcePath": source_path,
            "sourceTree": tree,
            "importedAt": source["importedAt"],
            "importMode": MODE,
        }
        runtime_packages = ["gh"] if collection == "tstack" else []
        if skill_id == "babysit-pr":
            runtime_packages.append("python3")
        metadata = {
            **previous,
            "id": skill_id, "kind": "skill", "version": 1,
            "tags": tags, "groupIds": group_ids, "invocation": invocation,
            "runtimePackages": runtime_packages, "supportedAgents": agents,
            "helperTools": [], "mcpServers": [], "provenance": provenance,
            "outputs": {"skillPath": f"skills/{skill_id}", "skillFile": f"skills/{skill_id}/SKILL.md"},
        }
        write_json(destination / "skill.json", metadata)

        markdown = upstream_file.read_text()
        _, frontmatter, body = markdown.split("---", 2)
        if not re.search(rf"^name: {re.escape(skill_id)}$", frontmatter, re.MULTILINE):
            raise SystemExit(f"{skill_id}: upstream name must match its directory")
        summary = description(frontmatter).replace('\\"', '"')
        if skill_id == "unslop":
            summary += " Must always apply."
        header = f"---\nname: {skill_id}\ndescription: >\n  {summary}\nlicense: MIT\nmetadata:\n"
        for key, value in {
            "tags": ",".join(tags), "groups": ",".join(group_ids),
            "invocation": invocation,
            "source": f"{source['repository']}@{source['revision']}:{source_path}",
        }.items():
            header += f"  {key}: {json.dumps(value)}\n"
        body = pin_external_links(body, upstream_file, source_root, source)
        normalized = subprocess.check_output(
            ["perl", str(ROOT / "scripts" / "unslop-punctuation.pl")],
            input=header + "---" + body, text=True,
        )
        (destination / "SKILL.md").write_text(normalized.rstrip() + "\n")
        imports.append({
            "skillId": skill_id, "sourceId": source_id, "sourcePath": source_path,
            "sourceTree": tree, "tags": tags, "groupIds": group_ids,
            "supportedAgents": agents,
        })
        if skill_id not in assigned:
            groups[collection]["skillIds"].append(skill_id)
            assigned.add(skill_id)

    removed = {key for key, item in existing_imports.items() if item["sourceId"] == source_id} - {item["skillId"] for item in imports}
    if removed:
        raise SystemExit(f"{source_id}: upstream removed skills; review before deleting {sorted(removed)}")
    manifest["imports"] = [item for item in manifest["imports"] if item["sourceId"] != source_id] + imports
    license_path = ROOT / source["licenseFile"]
    license_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source_root / "LICENSE", license_path)
    print(f"Imported {len(imports)} {collection} skills at {source['revision']}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tstack", required=True, type=Path)
    parser.add_argument("--pstack", required=True, type=Path)
    arguments = parser.parse_args()
    manifest_path = ROOT / "catalog" / "upstream-sources.json"
    catalog_path = ROOT / "catalog" / "installable-skills.json"
    manifest = json.loads(manifest_path.read_text())
    catalog = json.loads(catalog_path.read_text())
    for collection, label in [("tstack", "Theo Browne's tstack"), ("pstack", "Additional Poteto pstack skills")]:
        if not any(group["name"] == collection for group in catalog["groups"]):
            catalog["groups"].append({"name": collection, "label": label, "activation": {"mode": "manual"}, "skillIds": []})
    import_stack("theo-tstack", arguments.tstack.resolve(), manifest, catalog)
    import_stack("cursor-pstack", arguments.pstack.resolve(), manifest, catalog)
    write_json(manifest_path, manifest)
    write_json(catalog_path, catalog)
    subprocess.run(["node", str(ROOT / "scripts" / "unslop-headings.mjs"), str(ROOT)], check=True)
    subprocess.run(["bash", str(ROOT / "scripts" / "build-smol-agent-source-config.sh")], check=True)


if __name__ == "__main__":
    main()
