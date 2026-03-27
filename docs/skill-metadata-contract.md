# Skill Metadata Contract

Snapshot date: 2026-03-26

This repo now has four parallel contracts:

- `SKILL.md`: human-facing and agent-facing instructions
- `skill.json`: machine-facing metadata for Nix and bootstrap tooling
- `tool.json`: machine-facing metadata for repo-owned helper tools
- `agent-metadata.json`: machine-facing metadata for agent definitions

`SKILL.md` remains the standards-facing artifact for Agent Skills and `npx skills`.

`skill.json` and `tool.json` exist so we do not need to scrape prose to answer operational questions like:

- which packages should be present on the machine
- which agents a skill is intended for
- which helper tools or MCP servers are expected
- where the installable skill files live
- which repo-owned executables should be packaged into the user environment
- where agent definitions live and which skills they conceptually depend on

## Minimal Schema

Each metadata-backed skill can define `skills/<id>/skill.json` with this shape:

```json
{
  "id": "expo-build-validation",
  "kind": "skill",
  "version": 1,
  "runtimePackages": ["jq"],
  "supportedAgents": ["codex", "claude-code", "kiro-cli"],
  "helperTools": [],
  "mcpServers": [],
  "outputs": {
    "skillPath": "skills/expo-build-validation",
    "skillFile": "skills/expo-build-validation/SKILL.md"
  }
}
```

Each repo-owned tool can define `tools/<id>/tool.json` with this shape:

```json
{
  "id": "skill-bootstrap",
  "kind": "tool",
  "version": 1,
  "packageName": "skill-bootstrap",
  "runtimePackages": ["bash"],
  "entrypoint": "tools/skill-bootstrap/bootstrap-skills.sh"
}
```

Each agent can define `agents/<id>/agent-metadata.json` with this shape:

```json
{
  "id": "react-frontend",
  "kind": "agent",
  "version": 1,
  "definitionFile": "agents/react-frontend/agent.json",
  "supportedAgents": ["kiro-cli"],
  "skillIds": ["react-project-init"],
  "helperTools": []
}
```

## Field Semantics

- `id`: canonical identifier. Must match the skill directory name.
- `kind`: currently `skill`. Reserve room for future `agent` and `tool` metadata.
- `version`: schema version for this metadata contract, not the skill's product version.
- `runtimePackages`: package names expected to resolve from `pkgs` in Nix.
- `supportedAgents`: agent runtimes this skill is meant to support.
- `helperTools`: repo-owned helper tools or wrappers a skill expects.
- `mcpServers`: MCP server identifiers the skill expects to be available.
- `outputs.skillPath`: repo-relative directory for the skill.
- `outputs.skillFile`: repo-relative `SKILL.md` path.
- `helperTools`: tool ids from `tool.json` metadata that should be installed alongside the skill.

Tool metadata fields:

- `id`: canonical tool identifier. Must match the tool directory name.
- `kind`: currently `tool`.
- `version`: schema version for tool metadata.
- `packageName`: executable/package name exported by the flake.
- `runtimePackages`: package names expected to resolve from `pkgs` in Nix.
- `entrypoint`: repo-relative executable script path.

Agent metadata fields:

- `id`: canonical agent identifier. Must match the agent directory name.
- `kind`: currently `agent`.
- `version`: schema version for agent metadata.
- `definitionFile`: repo-relative path to the agent definition file.
- `supportedAgents`: runtimes that can consume this agent definition format.
- `skillIds`: skill ids the agent is expected to use or expose.
- `helperTools`: tool ids the agent expects to have available.

## Flake Contract

The starter flake exposes:

- `skillMetadata`
- `toolMetadata`
- `agentMetadata`
- `packages`
- `homeManagerModules.default`

`skillMetadata` is an attrset aggregated from every `skills/*/skill.json` file in the repo.
`toolMetadata` is an attrset aggregated from every `tools/*/tool.json` file in the repo.
`agentMetadata` is an attrset aggregated from every `agents/*/agent-metadata.json` file in the repo.

The Home Manager module:

- installs resolved runtime packages from selected skills
- installs helper tool packages referenced by selected skills or explicitly requested
- links selected `SKILL.md` files into a user-controlled install root
- links selected `agent.json` files into a user-controlled agent install root

This is intentionally small. It is a starter contract, not the final packaging system.

## Why This Split

This keeps the standards boundary clean:

- `npx skills` and Agent Skills tooling rely on `SKILL.md`
- Nix and machine bootstrap rely on `skill.json`

That lets public and private repos share the same operational contract without overloading the skill prose.

## Current Scope

The first metadata-backed skills are:

- `expo-build-validation`
- `expo-build-submit`

The first metadata-backed tool is:

- `skill-bootstrap`

The first metadata-backed agent is:

- `react-frontend`

That is enough to prove the shape before scaling it to more skills or the future Maestro QA suite.

## Verification

Run:

```bash
./tests/verify-contract.sh
```

The script verifies:

- the sample metadata file exists
- the second sample metadata file exists
- the first tool metadata file exists
- the first agent metadata file exists
- the starter flake exists
- the Home Manager module exists
- the metadata has expected keys
- Nix can evaluate `.#skillMetadata.expo-build-validation.id`
- Nix can evaluate `.#skillMetadata.expo-build-submit.id`
- Nix can evaluate `.#toolMetadata.skill-bootstrap.id`
- Nix can evaluate `.#agentMetadata.react-frontend.id`
- Nix can evaluate `.#packages.<system>.skill-bootstrap.name`
- Nix can evaluate `.#homeManagerModules.default`
