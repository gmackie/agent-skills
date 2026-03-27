---
name: unity-scripting-advanced
description: Advanced Unity C# scripting patterns, component architecture, and AI-assisted development with unity-mcp. Use for complex gameplay systems, performance optimization, and maintainable code.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: gamedev
  compatibility: Requires Unity Editor, unity-mcp, Visual Studio/Rider
---

# Unity Advanced Scripting

## Instructions

### 1. Component-based architecture with AI assistance

**Modular component design:**
```csharp
// Base interfaces for modular systems
public interface IHealth
{
    float CurrentHealth { get; }
    float MaxHealth { get; }
    void TakeDamage(float damage);
    void Heal(float amount);
}

public interface IMovement
{
    Vector3 Velocity { get; }
    void Move(Vector3 direction);
    void Stop();
}

// Implementation with AI-friendly logging
public class HealthComponent : MonoBehaviour, IHealth
{
    [SerializeField] private float maxHealth = 100f;
    [SerializeField] private float currentHealth;
    
    public float CurrentHealth => currentHealth;
    public float MaxHealth => maxHealth;
    
    public UnityEvent<float> OnHealthChanged;
    public UnityEvent OnDeath;
    
    void Start()
    {
        currentHealth = maxHealth;
        Debug.Log($"[Health] {gameObject.name} initialized with {maxHealth} HP");
    }
    
    public void TakeDamage(float damage)
    {
        float oldHealth = currentHealth;
        currentHealth = Mathf.Max(0, currentHealth - damage);
        
        Debug.Log($"[Health] {gameObject.name} took {damage} damage. {oldHealth} -> {currentHealth}");
        
        OnHealthChanged?.Invoke(currentHealth);
        
        if (currentHealth <= 0)
        {
            Debug.Log($"[Health] {gameObject.name} died");
            OnDeath?.Invoke();
        }
    }
    
    public void Heal(float amount)
    {
        float oldHealth = currentHealth;
        currentHealth = Mathf.Min(maxHealth, currentHealth + amount);
        
        Debug.Log($"[Health] {gameObject.name} healed {amount}. {oldHealth} -> {currentHealth}");
        OnHealthChanged?.Invoke(currentHealth);
    }
}
```

### 2. ScriptableObject data architecture

**Game data management:**
```csharp
// Weapon data ScriptableObject
[CreateAssetMenu(fileName = "New Weapon", menuName = "Game/Weapon")]
public class WeaponData : ScriptableObject
{
    [Header("Basic Stats")]
    public string weaponName;
    public float damage;
    public float fireRate;
    public float range;
    
    [Header("Audio/Visual")]
    public AudioClip fireSound;
    public GameObject muzzleFlash;
    public GameObject projectilePrefab;
    
    [Header("AI Analysis")]
    [TextArea(3, 5)]
    public string aiDescription; // For AI to understand weapon behavior
    
    public void LogWeaponStats()
    {
        Debug.Log($"Weapon: {weaponName} | Damage: {damage} | Fire Rate: {fireRate} | Range: {range}");
    }
}

// Weapon controller using ScriptableObject
public class WeaponController : MonoBehaviour
{
    [SerializeField] private WeaponData weaponData;
    [SerializeField] private Transform firePoint;
    
    private float lastFireTime;
    
    void Start()
    {
        if (weaponData != null)
        {
            Debug.Log($"[Weapon] {gameObject.name} equipped with {weaponData.weaponName}");
            weaponData.LogWeaponStats();
        }
    }
    
    public void Fire()
    {
        if (Time.time - lastFireTime < 1f / weaponData.fireRate) return;
        
        lastFireTime = Time.time;
        
        // Instantiate projectile
        if (weaponData.projectilePrefab != null)
        {
            GameObject projectile = Instantiate(weaponData.projectilePrefab, firePoint.position, firePoint.rotation);
            
            // Configure projectile with weapon data
            var projectileScript = projectile.GetComponent<Projectile>();
            if (projectileScript != null)
            {
                projectileScript.Initialize(weaponData.damage, weaponData.range);
            }
        }
        
        Debug.Log($"[Weapon] {weaponData.weaponName} fired! Damage: {weaponData.damage}");
    }
}
```

### 3. Event-driven programming with UnityEvents

**Decoupled event system:**
```csharp
// Game event system
[CreateAssetMenu(fileName = "New Game Event", menuName = "Events/Game Event")]
public class GameEvent : ScriptableObject
{
    private List<GameEventListener> listeners = new List<GameEventListener>();
    
    public void Raise()
    {
        Debug.Log($"[Event] {name} raised with {listeners.Count} listeners");
        
        for (int i = listeners.Count - 1; i >= 0; i--)
        {
            listeners[i].OnEventRaised();
        }
    }
    
    public void RegisterListener(GameEventListener listener)
    {
        listeners.Add(listener);
        Debug.Log($"[Event] Listener registered to {name}. Total: {listeners.Count}");
    }
    
    public void UnregisterListener(GameEventListener listener)
    {
        listeners.Remove(listener);
        Debug.Log($"[Event] Listener unregistered from {name}. Total: {listeners.Count}");
    }
}

public class GameEventListener : MonoBehaviour
{
    [SerializeField] private GameEvent gameEvent;
    [SerializeField] private UnityEvent response;
    
    void OnEnable()
    {
        gameEvent?.RegisterListener(this);
    }
    
    void OnDisable()
    {
        gameEvent?.UnregisterListener(this);
    }
    
    public void OnEventRaised()
    {
        Debug.Log($"[EventListener] {gameObject.name} responding to {gameEvent.name}");
        response?.Invoke();
    }
}
```

### 4. AI-assisted code generation with unity-mcp

**Ask AI to generate systems:**
```
"Create a state machine for enemy AI behavior"
"Generate a dialogue system with branching conversations"
"Build a inventory system with drag-and-drop functionality"
"Create a save/load system using JSON serialization"
```

**Example AI-generated state machine:**
```csharp
// AI can generate this via unity-mcp
public abstract class State
{
    public abstract void Enter();
    public abstract void Update();
    public abstract void Exit();
}

public class StateMachine : MonoBehaviour
{
    private State currentState;
    
    public void ChangeState(State newState)
    {
        if (currentState != null)
        {
            Debug.Log($"[StateMachine] Exiting state: {currentState.GetType().Name}");
            currentState.Exit();
        }
        
        currentState = newState;
        
        if (currentState != null)
        {
            Debug.Log($"[StateMachine] Entering state: {currentState.GetType().Name}");
            currentState.Enter();
        }
    }
    
    void Update()
    {
        currentState?.Update();
    }
}

// Example states
public class IdleState : State
{
    private EnemyController enemy;
    
    public IdleState(EnemyController enemy) { this.enemy = enemy; }
    
    public override void Enter()
    {
        Debug.Log($"[AI] {enemy.name} entering idle state");
        enemy.SetAnimationState("Idle");
    }
    
    public override void Update()
    {
        // Check for player in range
        if (enemy.PlayerInRange())
        {
            enemy.StateMachine.ChangeState(new ChaseState(enemy));
        }
    }
    
    public override void Exit()
    {
        Debug.Log($"[AI] {enemy.name} exiting idle state");
    }
}
```

### 5. Performance optimization patterns

**Object pooling with AI monitoring:**
```csharp
public class ObjectPool<T> : MonoBehaviour where T : MonoBehaviour
{
    [SerializeField] private T prefab;
    [SerializeField] private int initialSize = 10;
    [SerializeField] private bool allowGrowth = true;
    
    private Queue<T> pool = new Queue<T>();
    private List<T> activeObjects = new List<T>();
    
    void Start()
    {
        InitializePool();
    }
    
    void InitializePool()
    {
        for (int i = 0; i < initialSize; i++)
        {
            T obj = Instantiate(prefab);
            obj.gameObject.SetActive(false);
            pool.Enqueue(obj);
        }
        
        Debug.Log($"[ObjectPool] Initialized pool for {typeof(T).Name} with {initialSize} objects");
    }
    
    public T Get()
    {
        T obj;
        
        if (pool.Count > 0)
        {
            obj = pool.Dequeue();
        }
        else if (allowGrowth)
        {
            obj = Instantiate(prefab);
            Debug.Log($"[ObjectPool] Pool expanded for {typeof(T).Name}. New size: {activeObjects.Count + 1}");
        }
        else
        {
            Debug.LogWarning($"[ObjectPool] Pool exhausted for {typeof(T).Name}!");
            return null;
        }
        
        obj.gameObject.SetActive(true);
        activeObjects.Add(obj);
        return obj;
    }
    
    public void Return(T obj)
    {
        if (activeObjects.Remove(obj))
        {
            obj.gameObject.SetActive(false);
            pool.Enqueue(obj);
        }
    }
    
    [ContextMenu("Log Pool Stats")]
    public void LogPoolStats()
    {
        Debug.Log($"[ObjectPool] {typeof(T).Name} - Active: {activeObjects.Count}, Pooled: {pool.Count}");
    }
}
```

### 6. Custom editor tools for AI integration

**Custom inspector for AI analysis:**
```csharp
#if UNITY_EDITOR
using UnityEditor;

[CustomEditor(typeof(WeaponController))]
public class WeaponControllerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        
        WeaponController weapon = (WeaponController)target;
        
        GUILayout.Space(10);
        GUILayout.Label("AI Analysis Tools", EditorStyles.boldLabel);
        
        if (GUILayout.Button("Generate AI Description"))
        {
            // This could trigger unity-mcp to analyze the weapon
            Debug.Log("AI: Analyzing weapon configuration...");
        }
        
        if (GUILayout.Button("Optimize Performance"))
        {
            Debug.Log("AI: Suggesting performance optimizations...");
        }
        
        if (GUILayout.Button("Test Weapon Balance"))
        {
            Debug.Log("AI: Running weapon balance analysis...");
        }
    }
}
#endif
```

## Examples

### AI-Assisted Development Workflow
```
1. "Create a player controller with jump, dash, and wall-slide mechanics"
2. "Generate a dialogue system with character portraits and typing effects"
3. "Build an inventory system with item tooltips and drag-drop"
4. "Create a quest system with objectives and rewards"
5. "Implement a save system that persists player progress"
```

### Performance Monitoring
```csharp
public class PerformanceProfiler : MonoBehaviour
{
    [Header("Monitoring")]
    public bool enableProfiling = true;
    public float updateInterval = 1f;
    
    private float timer;
    
    void Update()
    {
        if (!enableProfiling) return;
        
        timer += Time.deltaTime;
        if (timer >= updateInterval)
        {
            LogPerformanceMetrics();
            timer = 0f;
        }
    }
    
    void LogPerformanceMetrics()
    {
        Debug.Log($"[Performance] FPS: {1f/Time.unscaledDeltaTime:F1}");
        Debug.Log($"[Performance] Memory: {System.GC.GetTotalMemory(false) / 1024 / 1024}MB");
        Debug.Log($"[Performance] Active GameObjects: {FindObjectsOfType<GameObject>().Length}");
    }
}
```

## Troubleshooting

- **unity-mcp script generation fails**: Ensure proper project structure and namespace usage
- **Performance issues with generated code**: Ask AI to optimize specific bottlenecks
- **Component dependencies missing**: Use RequireComponent attribute and validation
- **Event system not firing**: Check listener registration and ScriptableObject references
- **State machine transitions broken**: Add debug logs to track state changes
- **Object pool memory leaks**: Ensure proper Return() calls and object cleanup
