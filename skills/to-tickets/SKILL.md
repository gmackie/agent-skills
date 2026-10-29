---
name: to-tickets
description: Break a plan, spec, or the current conversation into tracer-bullet tickets that declare their blocking edges. Publish edges as text in one file per ticket locally or as native blocking links on a real tracker.
license: MIT
metadata:
  tags: "issue-tracker,planning,tickets"
  groups: "issue-workflow"
  invocation: "user"
  source: "https://github.com/mattpocock/skills@84fdeffd12f2ee307994d1eb6feb48173b6e0502:skills/engineering/to-tickets"
---

# To tickets

Break a plan, spec, or conversation into **tickets**. Each ticket is a tracer-bullet vertical slice that declares which tickets **block** it.

The issue tracker and triage label vocabulary should have been provided to you. Run `/setup-matt-pocock-skills` if not.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer: schema, API, UI, and tests. It is vertical, NOT a horizontal slice of one layer.
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**. These are the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change, such as renaming a column or retyping a shared symbol, whose **blast radius** fans across the whole codebase. A single edit breaks thousands of call sites at once, so no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand-contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites in batches sized by blast radius (per package, per directory). Give each batch its own ticket blocked by the expand. CI stays green from batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migration batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch. Make them all block a final integrate-and-verify ticket; green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct? Does each ticket depend only on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets to the configured tracker

Publish the approved tickets. **How** depends on the tracker `/setup-matt-pocock-skills` configured. The tickets are the same either way; only the shape of the blocking edges changes:

- **Local files.** Write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers first). Each file's "Blocked by" lists the numbers and titles it depends on. Use the per-ticket file template below. Write one ticket per file, never a single combined file.
- **A real issue tracker (GitHub, Linear, etc.).** Publish one issue per ticket in dependency order (blockers first) so each ticket's blocking edges can reference real identifiers. Use the platform's native blocking or sub-issue relationship where it has one; otherwise set each ticket's "Blocked by" to the blocking issues. Apply the `ready-for-agent` triage label unless instructed otherwise. The tickets are agent-grabbable by construction.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means top to bottom.

Do NOT close or modify any parent issue.

<local-ticket-template>

# <NN>: <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work from the user's perspective. Do not provide a layer-by-layer implementation list.

**Blocked by:** the numbers and titles of the tickets that gate this one, or "None; can start immediately".

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-ticket-template>

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit this section).

## What to build

The end-to-end behaviour this ticket makes work from the user's perspective. Do not provide a layer-by-layer implementation list.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None; can start immediately".

</issue-template>

In either form, avoid specific file paths or code snippets because they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim it to the decision-rich parts. Include the important bits, not a working demo.
