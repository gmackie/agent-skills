# Nix Consumption Example

Snapshot date: 2026-03-27

This repo now includes an example Home Manager module showing how `../nix-config` should consume the public repo and a future private repo together.

## Example Module

See:

- [combined-home-manager.nix](/Volumes/dev/agent-skills/nix/examples/combined-home-manager.nix)

It is a function that takes:

- `publicFlake`
- `privateFlake ? null`

and returns a Home Manager module that:

- imports the public repo's `homeManagerModules.default`
- optionally imports the private repo's `homeManagerModules.default`
- selects public skills, tools, and agents declaratively

## Intended `nix-config` Usage

The intended consumer is a machine config repo like `../nix-config`.

At the flake level, that repo should define inputs like:

```nix
{
  inputs = {
    agent-skills.url = "github:gmackie/agent-skills";
    agent-skills-private.url = "git+ssh://git@github.com/gmackie/agent-skills-private";
  };
}
```

Then in Home Manager:

```nix
{
  imports = [
    (import ../agent-skills/nix/examples/combined-home-manager.nix {
      publicFlake = inputs.agent-skills;
      privateFlake = inputs.agent-skills-private;
    })
  ];
}
```

If the private repo is unavailable on a given machine, pass `privateFlake = null`.

## Why This Shape

This keeps the consumption boundary simple:

- each repo exports the same metadata contract
- each repo exports the same Home Manager module interface
- `nix-config` only decides which repos and ids to enable

That means public and private repos can evolve independently without changing the consuming pattern.

## Recommended Follow-Up

The next step in `../nix-config` should be a thin wrapper module that:

- declares both flake inputs
- imports this example pattern
- maps agent-specific install roots if needed
- installs extra machine-level dependencies like `node`, `git`, Maestro, and MCP servers
