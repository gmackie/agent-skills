# Skill Writer

A meta-skill for designing and creating new reusable skills.

## Purpose
Help design, structure, and implement new skills that can be used across projects and by different agents.

## Usage
When creating a new skill, consider:

1. **Skill Scope**: What specific task or capability does this skill provide?
2. **Inputs**: What information/parameters does the skill need?
3. **Outputs**: What does the skill produce or accomplish?
4. **Dependencies**: What tools, libraries, or environment setup is required?
5. **Reusability**: How can this be generalized for different projects?

## Skill Template Structure

Create a skill directory with this structure:
```
my-skill/
├── SKILL.md (required)
├── reference.md (optional documentation)
├── examples.md (optional examples)
├── scripts/
│   └── helper.py (optional utility)
└── templates/
    └── template.txt (optional template)
```

### SKILL.md Format
```markdown
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
allowed-tools: fs_read, fs_write, execute_bash
---

# Your Skill Name

## Instructions
Provide clear, step-by-step guidance.

1. First step
2. Second step
3. Third step

## Examples
Show concrete examples of using this Skill.

### Example 1: Basic Usage
\`\`\`bash
command example
\`\`\`

### Example 2: Advanced Usage
\`\`\`bash
advanced command
\`\`\`

## Troubleshooting
- **Issue**: Solution
- **Issue**: Solution
```

### Frontmatter Fields
- `name`: Unique identifier for the skill (required)
- `description`: Brief description of what the skill does (required)
- `allowed-tools`: Comma-separated list of tools the skill can use (optional)

### Allowed Tools
Use `allowed-tools` to limit which tools can be used when a skill is active:
- `fs_read`: Read files
- `fs_write`: Write/modify files
- `execute_bash`: Run bash commands
- `knowledge`: Access knowledge base
- `delegate`: Use sub-agents

Example for read-only skill:
```markdown
---
name: safe-file-reader
description: Read files without making changes
allowed-tools: fs_read
---
```

## Skill Categories

### Development Skills
- Project initialization
- Code generation
- Testing and debugging
- Build and deployment

### Configuration Skills
- Environment setup
- Tool configuration
- Dependency management

### Workflow Skills
- Git workflows
- CI/CD setup
- Code review processes

## Best Practices

1. **Keep skills atomic**: Each skill should do one thing well
2. **Make skills composable**: Skills should work together
3. **Document thoroughly**: Include examples and edge cases
4. **Version control**: Track changes to skills over time
5. **Test skills**: Verify they work in clean environments

## Creating a New Skill

### Quick Start
```bash
# 1. Create skill directory
mkdir -p skills/my-skill

# 2. Create SKILL.md
cat > skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Description of what this skill does
allowed-tools: fs_read, fs_write, execute_bash
---

# My Skill

## Instructions
1. Step one
2. Step two
3. Step three

## Examples
\`\`\`bash
example command
\`\`\`

## Troubleshooting
- **Issue**: Solution
EOF

# 3. Test the skill
kiro-cli chat --context skills/my-skill/SKILL.md
```

### Validation Checklist
- [ ] Clear purpose statement
- [ ] All prerequisites listed
- [ ] Step-by-step instructions
- [ ] At least one working example
- [ ] Troubleshooting section
- [ ] Tested in clean environment
