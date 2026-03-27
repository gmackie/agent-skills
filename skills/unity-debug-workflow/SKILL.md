---
name: unity-debug-workflow
description: Debug Unity projects using console logs, breakpoints, profiler, and unity-mcp integration. Use when troubleshooting Unity games, performance issues, or runtime errors.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: gamedev
  compatibility: Requires Unity Editor, unity-mcp for AI integration
---

# Unity Debug Workflow

## Instructions

### 1. Set up unity-mcp for AI-assisted debugging

**Install unity-mcp:**
```bash
# Install Python and uv
curl -LsSf https://astral.sh/uv/install.sh | sh  # macOS/Linux
# or winget install --id=astral-sh.uv -e  # Windows

# Unity will auto-install the MCP server when you open Window > MCP for Unity
```

**Configure in Unity:**
1. Open Unity project
2. Go to `Window > Package Manager`
3. Add package from git URL: `https://github.com/CoplayDev/unity-mcp.git?path=/MCPForUnity`
4. Open `Window > MCP for Unity`
5. Click "Start Local HTTP Server"
6. Configure your AI client (Claude, Cursor, etc.) to connect to `http://localhost:8080/mcp`

### 2. Console debugging with unity-mcp

**Basic logging:**
```csharp
// Enhanced logging for AI analysis
public class DebugLogger : MonoBehaviour
{
    [Header("Debug Settings")]
    public bool enableVerboseLogging = true;
    public LogLevel logLevel = LogLevel.Info;
    
    void Start()
    {
        // Context-rich logging for AI
        Debug.Log($"[{gameObject.name}] Started at position {transform.position}");
        LogSystemInfo();
    }
    
    void LogSystemInfo()
    {
        Debug.Log($"Platform: {Application.platform}");
        Debug.Log($"Unity Version: {Application.unityVersion}");
        Debug.Log($"Target FPS: {Application.targetFrameRate}");
    }
    
    public void LogError(string context, System.Exception ex)
    {
        Debug.LogError($"[ERROR] {context}: {ex.Message}\nStack: {ex.StackTrace}");
    }
}
```

**AI-assisted log analysis:**
Ask your AI: "Analyze the Unity console logs and identify performance bottlenecks"

### 3. Breakpoint debugging

**Set up Visual Studio/Rider debugging:**
```csharp
public class PlayerController : MonoBehaviour
{
    [SerializeField] private float speed = 5f;
    private Rigidbody rb;
    
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        // Set breakpoint here to inspect component state
        Debug.Assert(rb != null, "Rigidbody component missing!");
    }
    
    void Update()
    {
        float input = Input.GetAxis("Horizontal");
        // Set breakpoint to inspect input values
        if (Mathf.Abs(input) > 0.1f)
        {
            MovePlayer(input);
        }
    }
    
    void MovePlayer(float input)
    {
        Vector3 movement = new Vector3(input * speed, 0, 0);
        // Breakpoint here to debug movement calculations
        rb.AddForce(movement, ForceMode.VelocityChange);
    }
}
```

### 4. AI-assisted debugging with unity-mcp

**Query AI for debugging help:**
```
"Check the Unity console for errors and suggest fixes"
"Analyze the current scene hierarchy for performance issues"
"Create a debug script to monitor player movement"
"Find all GameObjects with missing components"
```

**Custom debug tools via AI:**
```csharp
// AI can generate this via unity-mcp
public class DebugTools : MonoBehaviour
{
    [Header("Debug Visualization")]
    public bool showGizmos = true;
    public Color gizmoColor = Color.red;
    
    void OnDrawGizmos()
    {
        if (!showGizmos) return;
        
        // Visualize colliders
        Collider col = GetComponent<Collider>();
        if (col != null)
        {
            Gizmos.color = gizmoColor;
            Gizmos.DrawWireCube(col.bounds.center, col.bounds.size);
        }
    }
    
    [ContextMenu("Validate Components")]
    public void ValidateComponents()
    {
        Component[] components = GetComponents<Component>();
        foreach (var comp in components)
        {
            if (comp == null)
            {
                Debug.LogError($"Missing component on {gameObject.name}");
            }
        }
    }
}
```

## Examples

### AI-Assisted Debugging Session
```
1. Ask AI: "Check Unity console for errors"
2. AI uses unity-mcp to read console logs
3. Ask AI: "Create a debug script for the player movement issue"
4. AI generates and applies the debug script
5. Ask AI: "Analyze the profiler data for performance bottlenecks"
```

### Performance Debugging
```csharp
// AI can generate this monitoring script
public class PerformanceDebugger : MonoBehaviour
{
    void Update()
    {
        if (Time.frameCount % 60 == 0) // Every 60 frames
        {
            LogPerformanceMetrics();
        }
    }
    
    void LogPerformanceMetrics()
    {
        Debug.Log($"Draw Calls: {UnityStats.drawCalls}");
        Debug.Log($"Triangles: {UnityStats.triangles}");
        Debug.Log($"Batches: {UnityStats.batches}");
    }
}
```

## Troubleshooting

- **unity-mcp not connecting**: Ensure HTTP server is running in Unity window, check port 8080
- **AI can't see Unity state**: Verify MCP client configuration points to correct endpoint
- **Breakpoints not hitting**: Check if script debugging is enabled in Unity preferences
- **Console logs not showing**: Verify log level settings in Console window
- **Profiler data incomplete**: Enable Deep Profiling for detailed call stacks
- **Performance issues**: Use Frame Debugger to analyze rendering pipeline
