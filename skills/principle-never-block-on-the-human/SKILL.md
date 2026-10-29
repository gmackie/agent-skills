---
name: principle-never-block-on-the-human
description: >
  Apply when tempted to ask 'should I do X?' on reversible work.
license: MIT
metadata:
  tags: "autonomy,execution,human-in-loop,pstack"
  groups: "execution-principles"
  invocation: "user"
  source: "https://github.com/cursor/plugins@1ba91fc25c0977741dd0e267849e6234b037ed0a:pstack/skills/principle-never-block-on-the-human"
---

# Never Block on the Human

The human supervises asynchronously. Agents must stay unblocked. Make reasonable decisions, proceed, and let the human course-correct after the fact. Since code changes are reversible and reviewable, a wrong decision usually costs less than blocking.

- Proceed, then present. Do the work, show the result. Don't ask "should I do X?" Do X, explain why.
- Make the system self-healing. When you notice a problem, log it and fix it in the next round.
- Irreversible actions (force-push, delete production data, send external messages) still require confirmation.
- Reversible actions (write code, edit notes, split tasks) should proceed without blocking.
- Product direction comes from the human. Execution should not block.
