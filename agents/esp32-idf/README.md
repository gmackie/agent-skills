# ESP32 IDF Developer Agent

Specialized agent for ESP32 embedded development using the ESP-IDF framework.

## Quick Start

```bash
# Load this agent in Kiro CLI
kiro-cli chat --context agents/esp32-idf/instructions.md

# Or add to your project context
kiro-cli chat --context agents/esp32-idf/instructions.md --context skills/esp32/
```

## Capabilities

- Initialize ESP32 projects with proper structure
- Configure WiFi, Bluetooth, and networking
- Create reusable components and drivers
- Debug hardware and software issues
- Implement peripheral interfaces (GPIO, I2C, SPI, UART)
- Set up OTA updates and partition management
- Optimize power consumption

## Available Skills

| Skill | Description |
|-------|-------------|
| `esp32/project-init` | Initialize new ESP-IDF project |
| `esp32/wifi-setup` | Configure WiFi connectivity |
| `esp32/component-create` | Create custom components |
| `esp32/build-flash-monitor` | Build, flash, and monitor |
| `esp32/menuconfig` | Configure project settings |
| `esp32/ota-setup` | Setup OTA updates |
| `esp32/bluetooth-setup` | Configure Bluetooth/BLE |
| `esp32/partition-config` | Manage flash partitions |

## Common Workflows

### Create New Project
```
User: "Create a new ESP32 project for temperature monitoring"
Agent: [Uses project-init skill, sets up structure, adds sensor component]
```

### Add WiFi
```
User: "Add WiFi connectivity to send data to cloud"
Agent: [Uses wifi-setup skill, implements connection handling]
```

### Debug Issue
```
User: "Device keeps crashing with stack overflow"
Agent: [Analyzes logs, suggests stack size increase, implements fix]
```

## Example Interactions

**Example 1: New IoT Project**
```
User: I need to create an ESP32 project that reads from a DHT22 sensor 
      and sends data to an MQTT broker over WiFi.

Agent: I'll help you set up a complete IoT project. Let me:
       1. Initialize the project structure
       2. Add WiFi connectivity
       3. Create a DHT22 driver component
       4. Integrate MQTT client
       5. Implement the data flow
       
       [Proceeds with implementation using relevant skills]
```

**Example 2: Troubleshooting**
```
User: My ESP32 keeps resetting every few seconds

Agent: Let me help debug this. Common causes:
       - Watchdog timeout
       - Stack overflow
       - Power supply issues
       
       Can you share the serial monitor output? 
       Also, let's enable verbose logging...
       
       [Guides through debugging process]
```

## Prerequisites

- ESP-IDF v4.4 or later
- Python 3.7+
- CMake 3.16+
- Ninja build system
- USB drivers (CP210x or CH340)

## Configuration

The agent follows ESP-IDF best practices:
- Component-based architecture
- Proper error handling with ESP_ERROR_CHECK
- FreeRTOS task management
- Appropriate logging levels
- Hardware abstraction

## Tips

1. Always source ESP-IDF environment before starting: `. ~/esp/esp-idf/export.sh`
2. Use `idf.py menuconfig` for project configuration
3. Check serial output with `idf.py monitor` for debugging
4. Use `idf.py fullclean` when switching targets
5. Document hardware connections and pin assignments

## Related Resources

- [ESP-IDF Documentation](https://docs.espressif.com/projects/esp-idf/)
- [ESP32 Technical Reference](https://www.espressif.com/en/support/documents/technical-documents)
- Skills directory: `skills/esp32/`
