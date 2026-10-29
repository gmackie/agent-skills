---
name: principle-guard-the-context-window
description: >
  Apply when context is filling up: large outputs, long files, repeated reads, fan-out planning. Route bulk to subagents; keep summaries in the main thread, not raw payloads.
license: MIT
metadata:
  tags: "context,continuity,orchestration,pstack"
  groups: "core-quality"
  invocation: "user"
  source: "https://github.com/cursor/plugins@1ba91fc25c0977741dd0e267849e6234b037ed0a:pstack/skills/principle-guard-the-context-window"
---

# Guard the Context Window

**Why:** Context overflow degrades reasoning quality, creates compression artifacts, and halts progress.

**Pattern:**
- **Size phases and cap scope.** Limit files per phase, set turn budgets, account for mechanism costs.
