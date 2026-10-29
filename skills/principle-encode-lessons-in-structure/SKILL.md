---
name: principle-encode-lessons-in-structure
description: >
  Apply when you catch yourself writing the same instruction a second time, or notice a recurring correction. Encode the rule as a lint, metadata flag, runtime check, or script instead of more text.
license: MIT
metadata:
  tags: "automation,guardrails,pstack,quality"
  groups: "core-quality"
  invocation: "user"
  source: "https://github.com/cursor/plugins@1ba91fc25c0977741dd0e267849e6234b037ed0a:pstack/skills/principle-encode-lessons-in-structure"
---

# Encode Lessons in Structure

If the lesson needs judgment and cannot be encoded, make the instruction more prominent and add an example of the failure mode.

**Corollary:** If the fix is structural, only use the structural fix. The instruction is the symptom.
