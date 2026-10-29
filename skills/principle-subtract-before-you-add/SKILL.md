---
name: principle-subtract-before-you-add
description: >
  Apply when sequencing an addition, refactor, or rewrite. Remove dead code, redundant validators, and stub references first, then build on the simpler base.
license: MIT
metadata:
  tags: "pstack,refactoring,scope,simplicity"
  groups: "architecture"
  invocation: "user"
  source: "https://github.com/cursor/plugins@1ba91fc25c0977741dd0e267849e6234b037ed0a:pstack/skills/principle-subtract-before-you-add"
---

# Subtract Before You Add

When evolving a system, remove complexity first, then build. Default to subtraction.

Make simplification a continual investment. Leave the design slightly simpler and more capable behind the same or smaller surface than you found it.

- Sequence removal before construction
- Cut before you polish (get to the minimum before investing in quality)
- Design for observed usage, not speculative edge cases
- No speculative validators, parsers, or guards beyond what the spec demands
- Simplify prompts (remove redundant instructions, excessive templates)
- When a reference has no novel content, delete it rather than leaving a stub
