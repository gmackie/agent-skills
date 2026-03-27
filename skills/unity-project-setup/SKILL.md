---
name: unity-project-setup
description: Initialize a new Unity game project with proper structure, settings, and essential packages. Use when creating Unity games, prototypes, or interactive applications.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: gamedev
  compatibility: Requires Unity Editor and Unity Hub installed
---

# Unity Project Setup

## Instructions

1. **Create Unity project via Unity Hub**
- Open Unity Hub
- Click "New Project"
- Select Unity version (LTS recommended)
- Choose template: 3D (Core), 3D (URP), 2D, or 3D (HDRP)
- Set project name and location
- Click "Create Project"

2. **Set up folder structure in Assets**
```
Assets/
├── _Project/
│   ├── Scripts/
│   │   ├── Core/
│   │   ├── Gameplay/
│   │   ├── UI/
│   │   └── Utilities/
│   ├── Prefabs/
│   ├── Scenes/
│   ├── ScriptableObjects/
│   ├── Materials/
│   ├── Audio/
│   └── Animations/
└── Plugins/
```

3. **Configure project settings**
- Edit > Project Settings > Player
  - Set Company Name, Product Name, Version
  - Set Default Icon
- Edit > Project Settings > Quality
  - Configure quality levels for target platform
- Edit > Project Settings > Physics
  - Set up collision matrix

4. **Install essential packages**
Open Package Manager (Window > Package Manager):
- Input System (com.unity.inputsystem)
- TextMeshPro (com.unity.textmeshpro)
- Cinemachine (com.unity.cinemachine)

5. **Create GameManager script**
```csharp
// Assets/_Project/Scripts/Core/GameManager.cs
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
    }

    private void Start()
    {
        Initialize();
    }

    private void Initialize()
    {
        Debug.Log("Game initialized");
    }
}
```

6. **Create base scene structure**
```
Hierarchy:
├── --- MANAGEMENT ---
│   ├── GameManager
│   └── EventSystem
├── --- ENVIRONMENT ---
│   ├── Lighting
│   └── Ground
├── --- GAMEPLAY ---
│   └── Player
└── --- UI ---
    └── Canvas
```

7. **Configure version control (.gitignore)**
```gitignore
[Ll]ibrary/
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Ll]ogs/
[Uu]ser[Ss]ettings/
*.csproj
*.sln
*.suo
.vs/
.DS_Store
```

## Examples

### 2D Platformer Setup
```
1. Create 2D project
2. Install: Input System, Cinemachine, 2D Pixel Perfect
3. Set up layers: Player, Ground, Enemy, Collectible
4. Create player controller with Rigidbody2D
5. Set up Cinemachine virtual camera
```

### 3D Mobile Game Setup
```
1. Create 3D URP project
2. Install: Input System, TextMeshPro
3. Configure quality settings for mobile
4. Set up touch input actions
5. Optimize rendering settings
```

## Troubleshooting

- **Unity Hub doesn't show editors**: Manually locate installations or reinstall Unity Hub
- **Package installation fails**: Check internet connection, clear Package Manager cache
- **Input System conflicts**: Disable old input in Player Settings > Active Input Handling
- **Build fails**: Check all scenes added to build, verify platform modules installed
