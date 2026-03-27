# Agent Skills Library

This repo is a tracked source of truth for reusable agent skills and a smaller set of example agent definitions. The immediate goal is to keep the installable skill surface compatible with `npx skills` while growing stronger mobile, QA, and release-engineering coverage.

## Current Shape

The installable part of the repo is the `skills/` directory.

Each installable skill should live at:

```text
skills/<skill-name>/SKILL.md
```

`npx skills add . --list` currently detects the skills in this repo successfully.

The `agents/` directory is auxiliary. It contains example agent definitions, but the primary maintained artifact here should be reusable skills.

## Local Usage

List the skills available from this repo:

```bash
npx skills add . --list
```

Install one or more skills from this repo:

```bash
npx skills add . --skill expo-build-validation
npx skills add . --skill expo-build-submit --global
```

Install everything from this repo:

```bash
npx skills add . --skill '*'
```

## Repo Conventions

- Keep installable skills under `skills/<skill-name>/SKILL.md`.
- Add machine-readable metadata at `skills/<skill-name>/skill.json` when a skill has declarative dependency or bootstrap needs.
- Prefer minimal frontmatter: `name` and `description`.
- Move large supporting material into `references/`.
- Put reusable automation in `scripts/`.
- Treat `docs/` as repo guidance, not skill payload.
- Avoid flat markdown files in `skills/` for new work; prefer skill folders.

## Nix Contract

This repo now includes a starter `flake.nix` and Home Manager module.

Current purpose:

- aggregate `skill.json` metadata from the repo
- aggregate `tool.json` metadata from the repo
- aggregate `agent-metadata.json` metadata from the repo
- expose `skillMetadata` as a flake output
- expose `toolMetadata` and packaged helper tools as flake outputs
- expose `agentMetadata` as a flake output
- expose `homeManagerModules.default` for declarative installation

The split is:

- `SKILL.md`: agent-facing instructions
- `skill.json`: machine-facing dependency and install metadata
- `tool.json`: machine-facing metadata for repo-owned helper tools
- `agent-metadata.json`: machine-facing metadata for agent definitions

See:

- [docs/skill-metadata-contract.md](/Volumes/dev/agent-skills/docs/skill-metadata-contract.md)
- [docs/nix-consumption-example.md](/Volumes/dev/agent-skills/docs/nix-consumption-example.md)
- [flake.nix](/Volumes/dev/agent-skills/flake.nix)
- [home-manager-module.nix](/Volumes/dev/agent-skills/nix/home-manager-module.nix)

## Current Focus

The next area to build out is mobile development and QA:

- React Native / Expo release readiness
- Maestro-driven mobile QA
- App Store review preparation
- Better tracking of globally installed skills managed outside the repo

See:

- [docs/mobile-skills-roadmap.md](/Volumes/dev/agent-skills/docs/mobile-skills-roadmap.md)
- [docs/installed-global-skills.md](/Volumes/dev/agent-skills/docs/installed-global-skills.md)

## Existing Skills

Current installable skills include:

- Expo: `expo-build-validation`, `expo-build-submit`
- React: `react-project-init`, `react-debugging-advanced`, `react-ui-shadcn-tailwind`
- Next.js / SaaS: `nextjs-project-init`, `clerk-auth-integration`, `stripe-payments-integration`, `saas-turbo-bootstrap`
- Unity: `unity-project-setup`, `unity-scripting-advanced`, `unity-debug-workflow`
- ESP32: `esp32-project-init`, `esp32-wifi-setup`

## Notes

Some existing skills still reflect an older Kiro-style authoring format. They are installable today, but the repo should keep moving toward the simpler open skills layout used by `npx skills`.

# In chat
User: Create a 2D platformer with player movement and jumping
Agent: [Uses unity-project-setup, creates player controller, implements physics]
```

## 🔧 Extending the Library

### Adding a New Agent

1. Create agent directory: `mkdir -p agents/[name]`
2. Create configuration: `agents/[name]/agent.json`
3. Add documentation: `agents/[name]/README.md`
4. Create associated skills in `skills/[name]/`

**Example agent.json**:
```json
{
  "name": "my-agent",
  "description": "Description of what this agent does",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "resources": [
    "file://skills/my-category/**/*.md"
  ],
  "prompt": "You are a specialized agent for...",
  "model": "claude-sonnet-4"
}
```

### Adding a New Skill

1. Choose category or create new one
2. Create skill directory: `skills/[skill-name]/`
3. Create `SKILL.md` with frontmatter
4. Follow skill template structure
5. Include examples and troubleshooting
6. Test in real scenarios

**Example SKILL.md**:
```markdown
---
name: my-skill
description: What this skill does
allowed-tools: fs_read, fs_write, execute_bash
---

# My Skill

## Instructions
1. Step one
2. Step two

## Examples
\`\`\`bash
example
\`\`\`

## Troubleshooting
- **Issue**: Solution
```

### Best Practices

1. **Keep skills atomic**: Each skill should do one thing well
2. **Make skills composable**: Skills should work together
3. **Document thoroughly**: Include examples and edge cases
4. **Test in clean environments**: Verify skills work from scratch
5. **Version control**: Track changes to agents and skills
6. **Update regularly**: Keep skills current with latest tools

## 📚 Documentation

Each agent and skill includes:
- **Purpose**: What it does and why
- **Prerequisites**: Required tools and setup
- **Steps**: Detailed instructions
- **Examples**: Real-world usage scenarios
- **Troubleshooting**: Common issues and solutions
- **Related Skills**: Complementary skills

## 🤝 Contributing

To contribute new agents or skills:

1. Use the meta-skills (skill-writer.md, agent-creator.md)
2. Follow the established templates
3. Test thoroughly in clean environments
4. Document all prerequisites and steps
5. Include multiple examples
6. Add troubleshooting section

## 📖 Learning Path

### Beginner
1. Start with existing agents
2. Follow skills step-by-step
3. Understand the patterns

### Intermediate
1. Combine multiple skills
2. Customize agents for your needs
3. Create simple skills

### Advanced
1. Design new agents with agent-creator
2. Create comprehensive skill sets
3. Contribute to the library

## 🎯 Use Cases

### For Individual Developers
- Quick project setup
- Learn new tech stacks
- Consistent development patterns
- Reduce boilerplate work

### For Teams
- Standardize workflows
- Onboard new developers
- Share best practices
- Maintain consistency

### For Learning
- Step-by-step guides
- Real-world examples
- Best practices
- Troubleshooting help

## 🔗 Resources

### Agent Documentation
- [ESP32 IDF Agent](agents/esp32-idf/README.md)
- [React Frontend Agent](agents/react-frontend/README.md)
- [Unity Game Dev Agent](agents/unity-gamedev/README.md)
- [Next.js Web App Agent](agents/nextjs-webapp/README.md)

### Meta-Skills
- [Skill Writer](skills/skill-writer.md)
- [Agent Creator](skills/agent-creator.md)

### External Resources
- [Kiro CLI Documentation](https://docs.aws.amazon.com/kiro/)
- [ESP-IDF Documentation](https://docs.espressif.com/projects/esp-idf/)
- [React Documentation](https://react.dev)
- [Unity Documentation](https://docs.unity3d.com/)
- [Next.js Documentation](https://nextjs.org/docs)

## 📝 License

This library is provided as-is for educational and development purposes.

## 🙏 Acknowledgments

Built with best practices from:
- ESP-IDF community
- React ecosystem
- Unity developers
- Next.js community
- Open source contributors

---

**Ready to get started?** Choose an agent above or create your own with the meta-skills!
