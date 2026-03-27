# Agent Creator

A meta-skill for designing and creating new specialized agents.

## Purpose
Help design, configure, and implement new agents tailored to specific tech stacks or workflows.

## Agent Design Framework

### 1. Define Agent Identity
- **Name**: Clear, descriptive name
- **Domain**: Technology stack or workflow area
- **Expertise**: Specific capabilities and knowledge areas
- **Personality**: Communication style and approach

### 2. Identify Core Competencies
- Primary tasks the agent handles
- Technologies and tools it masters
- Common workflows it supports
- Problem domains it covers

### 3. Map Required Skills
- List all skills the agent needs
- Identify existing skills to reuse
- Note new skills to create
- Define skill priorities

### 4. Define Agent Behavior
- How it approaches problems
- Default workflows and patterns
- Error handling strategies
- Communication preferences

## Kiro CLI Agent Configuration Template

```json
{
  "name": "agent-name",
  "description": "Brief description of what this agent does",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "resources": [
    "file://skills/category/**/*.md"
  ],
  "prompt": "You are a specialized agent for [domain/technology].\n\n## Core Responsibilities\n1. Responsibility 1\n2. Responsibility 2\n\n## Available Skills\n- **skill-1**: Description\n- **skill-2**: Description\n\n## Workflow Patterns\nWhen the user wants to [goal]:\n1. Step 1\n2. Step 2\n\n## Best Practices\n- Always [practice 1]\n- Prefer [practice 2]\n\n## Common Commands\n```bash\n# Command examples\n```\n\n## Troubleshooting\n- Issue: Solution",
  "model": "claude-sonnet-4"
}
```

## Agent Instruction Template

```markdown
# [Agent Name]

You are a specialized agent for [domain/technology]. Your expertise includes [key areas].

## Core Responsibilities
1. Responsibility 1
2. Responsibility 2
3. Responsibility 3

## Available Skills
- **skill-1**: Description
- **skill-2**: Description
- **skill-3**: Description

## Workflow Patterns

### [Pattern Name]
When the user wants to [goal]:
1. Step 1
2. Step 2
3. Step 3

## Best Practices
- Always [practice 1]
- Prefer [practice 2]
- Avoid [anti-pattern]

## Communication Style
- [Style guideline 1]
- [Style guideline 2]

## Common Commands
\`\`\`bash
# Command examples
\`\`\`

## Troubleshooting Guide
[Common issues and solutions]
```

## Creating a New Agent

### Step-by-Step Process

1. **Research Phase**
   - Identify the domain/tech stack
   - List common tasks and workflows
   - Research best practices
   - Identify required tools

2. **Design Phase**
   - Define agent name and description
   - Write comprehensive instructions
   - List required skills/context files
   - Define workflows and patterns

3. **Implementation Phase**
   - Create agent directory: `agents/[agent-name]/`
   - Create `agent.yaml` with configuration
   - Create skill files in `skills/[category]/`
   - Write README with examples

4. **Testing Phase**
   - Test with: `kiro-cli chat --agent agents/[agent-name]/agent.yaml`
   - Verify skill integration
   - Test common workflows
   - Gather feedback

### Quick Start
```bash
# 1. Create agent directory
mkdir -p agents/my-agent

# 2. Create agent.json
cat > agents/my-agent/agent.json << 'EOF'
{
  "name": "my-agent",
  "description": "Description of agent",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "resources": [
    "file://skills/category/**/*.md"
  ],
  "prompt": "You are a specialized agent for [domain].\n\n[Add detailed instructions here]",
  "model": "claude-sonnet-4"
}
EOF

# 3. Create skills
mkdir -p skills/category
touch skills/category/skill-1.md

# 4. Test agent
kiro-cli chat --agent agents/my-agent/agent.json
```

## Agent Categories

### Development Agents
- Language-specific (Python, Rust, Go, etc.)
- Framework-specific (React, Next.js, Unity, etc.)
- Platform-specific (ESP32, Arduino, Raspberry Pi, etc.)

### DevOps Agents
- CI/CD specialists
- Infrastructure as Code
- Monitoring and observability

### Specialized Agents
- Security auditing
- Performance optimization
- Documentation generation

## Best Practices

1. **Single Responsibility**: Each agent should have a clear, focused domain
2. **Skill Reuse**: Leverage existing skills across agents
3. **Clear Instructions**: Agent behavior should be predictable
4. **Extensibility**: Design agents to be easily extended
5. **Documentation**: Thoroughly document capabilities and limitations

## Validation Checklist
- [ ] Clear agent identity and purpose
- [ ] All required skills identified
- [ ] At least 3 common workflows documented
- [ ] Tool requirements specified
- [ ] Best practices defined
- [ ] Communication style established
- [ ] Tested with real scenarios
- [ ] README with examples
