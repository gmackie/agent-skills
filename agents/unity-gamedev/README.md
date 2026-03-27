# Unity Game Developer Agent

Specialized agent for Unity game development covering gameplay programming, physics, UI, and optimization.

## Quick Start

```bash
# Load this agent in Kiro CLI
kiro-cli chat --context agents/unity-gamedev/instructions.md

# Or with skills
kiro-cli chat --context agents/unity-gamedev/instructions.md --context skills/unity/
```

## Capabilities

- Initialize Unity projects with proper structure
- Implement gameplay mechanics and systems
- Create player controllers and AI
- Build UI with Unity UI Toolkit or Canvas
- Set up physics and collision systems
- Implement animation systems
- Integrate audio and sound effects
- Optimize performance for target platforms
- Deploy builds for multiple platforms

## Available Skills

| Skill | Description |
|-------|-------------|
| `unity/project-setup` | Initialize Unity project with structure |
| `unity/script-create` | Create C# scripts with best practices |
| `unity/scene-management` | Manage scenes and scene transitions |
| `unity/input-system` | Set up new Input System |
| `unity/ui-implementation` | Build UI systems |
| `unity/physics-setup` | Configure physics and collisions |
| `unity/animation-setup` | Set up animations and controllers |
| `unity/audio-integration` | Integrate audio systems |
| `unity/build-deploy` | Build and deploy to platforms |

## Common Workflows

### Create New Game
```
User: "Create a 2D platformer project"
Agent: [Sets up Unity project, creates player controller, implements physics]
```

### Add Feature
```
User: "Add a double jump mechanic"
Agent: [Modifies player controller, implements jump logic, tests]
```

### Optimize Performance
```
User: "Game is running slow on mobile"
Agent: [Profiles, identifies issues, optimizes rendering and scripts]
```

## Example Interactions

**Example 1: New 3D Game**
```
User: I want to create a 3D third-person action game with 
      combat and camera controls.

Agent: I'll set up a complete 3D action game foundation:
       1. Create 3D URP project
       2. Set up player character with Rigidbody
       3. Implement third-person camera with Cinemachine
       4. Create combat system with animations
       5. Set up Input System for controls
       
       [Proceeds with implementation]
```

**Example 2: Performance Issue**
```
User: My game drops to 20 FPS when there are many enemies

Agent: Let me help optimize this. Common causes:
       - Too many draw calls
       - Inefficient scripts in Update()
       - No object pooling
       
       Let's profile and fix:
       [Uses Unity Profiler, implements object pooling, optimizes]
```

## Best Practices

The agent follows Unity best practices:

1. **Architecture**: Component-based design, separation of concerns
2. **Performance**: Object pooling, caching references, avoiding Update() when possible
3. **Code Quality**: C# conventions, XML documentation, clean code
4. **Assets**: Proper organization, ScriptableObjects for data
5. **Testing**: Regular profiling, testing on target devices
6. **Version Control**: Git-friendly project structure

## Project Structure

```
Assets/
├── _Project/
│   ├── Scripts/
│   │   ├── Core/          # Core systems
│   │   ├── Gameplay/      # Game mechanics
│   │   ├── UI/            # UI scripts
│   │   └── Utilities/     # Helper scripts
│   ├── Prefabs/           # Reusable objects
│   ├── Scenes/            # Game scenes
│   ├── ScriptableObjects/ # Data assets
│   └── Audio/             # Sound files
└── Plugins/               # Third-party assets
```

## Prerequisites

- Unity Hub
- Unity Editor (2021 LTS or later)
- Visual Studio or JetBrains Rider
- Basic C# knowledge

## Tips

1. Use Unity's new Input System for better control handling
2. Implement object pooling for frequently instantiated objects
3. Use ScriptableObjects for game data and configuration
4. Profile regularly with Unity Profiler
5. Cache component references in Awake() or Start()
6. Use events instead of Update() when possible
7. Organize assets with clear folder structure
8. Test on target platform early and often

## Related Resources

- [Unity Documentation](https://docs.unity3d.com/)
- [Unity Learn](https://learn.unity.com/)
- [Unity Manual](https://docs.unity3d.com/Manual/)
- [C# Programming Guide](https://docs.microsoft.com/en-us/dotnet/csharp/)
