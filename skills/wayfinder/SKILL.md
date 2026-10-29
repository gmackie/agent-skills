---
name: wayfinder
description: Plan work too large for one agent session as a shared map of decision tickets on your issue tracker. Resolve the tickets one at a time until the way to the destination is clear.
license: MIT
metadata:
  tags: "large-change,orchestration,planning"
  groups: "architecture"
  invocation: "user"
  source: "https://github.com/mattpocock/skills@84fdeffd12f2ee307994d1eb6feb48173b6e0502:skills/engineering/wayfinder"
---

A loose idea has arrived, too big for one agent session and wrapped in fog. The way from here to the **destination** isn't visible yet. Wayfinding finds that route instead of charging at the destination. This skill charts the route as a **shared map** on the repo's issue tracker. It then works through **decision tickets** one at a time until the route is clear. Each ticket poses a question whose resolution is a decision, not a slice of a build to execute.

The destination varies by effort. Naming it is the first act of charting because it shapes every ticket. It might be a spec to hand off and iterate on, a decision to lock before planning starts, or a change made in place like a data-structure migration. The map is domain-agnostic and can cover engineering work, course content, or anything else that fits this shape.

## Plan, don't do

Wayfinder is **planning** by default. Each ticket resolves a decision, and the map is done when the way is clear, with nothing left to decide before someone does the work. The pull to start the work usually means you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes** and carry execution into the map itself. Without that override, produce decisions, not deliverables.

## Refer by name

Every map and ticket is an issue, so its title is its **name**. In everything the human reads, including narration and the map's Decisions-so-far, refer to it by that name. Never use a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. Keep the id and URL inside the linked name, never in place of it.

## The map

The map is a single issue on this repo's issue tracker. Label it `wayfinder:map`; it is the canonical artifact. Its tickets are child issues of the map.

The map is an **index**, not a store. It lists the decisions made and points to the tickets that hold their details. A decision lives in exactly one place: its ticket. The map only summarizes and links to it.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** The issue tracker should have been provided to you. Run `/setup-matt-pocock-skills` if not. Consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them. If no tracker has been provided, default to the local Markdown tracker.

### The map body

Load the whole map at low resolution once per session. Open tickets are **not** listed in it; find them by querying its open child issues.

```markdown
## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index — one line per closed ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link) — <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Tickets

Each ticket is a **child issue** of the map; the tracker's issue id is its identity. Its body is the question, sized to one 100K token agent session:

```markdown
## Question

<the decision or investigation this ticket resolves>
```

Each ticket carries a `wayfinder:<type>` label: `research`, `prototype`, `grilling`, or `task` (see [Ticket types](#ticket-types)).

A session **claims** a ticket by first assigning it to the dev driving the map, before doing any work. Concurrent sessions then skip it. That assignee _is_ the claim: an open, unassigned ticket is unclaimed.

Blocking uses the tracker's **native** dependency relationship. This is essential because it renders the frontier _visually_ in the tracker's own UI, so the human sees what's available without opening the map. Only a tracker that lacks native blocking falls back to a body convention. A ticket is **unblocked** when every ticket blocking it is closed. The **frontier** is the set of open, unblocked, unclaimed children at the edge of the known.

The answer isn't part of the body. Record it on resolution (see [Work through the map](#work-through-the-map)). Link assets created while resolving a ticket from the issue; don't paste them in.

## Ticket types

Every ticket is either **HITL** or **AFK**. A HITL ticket is human in the loop and worked _with_ a human who speaks for themselves. An AFK ticket is driven by the agent alone. A HITL ticket only resolves through that live exchange; the agent never stands in for the human's side of it (a grilling agent that answers its own questions has broken this).

- **Research (AFK).** Read documentation, third-party APIs, or local resources such as knowledge bases to find a fact that a decision requires. Resolve it with a `/research` **subagent**. Use this type when the required knowledge lives outside the current working directory.
- **Prototype (HITL).** Raise the fidelity of the discussion by making a cheap, rough, concrete artifact to react to. This can be an outline, rough take, stub, or UI or logic code made with the `/prototype` skill. Link the prototype as an asset. Use this type when "how should it look" or "how should it behave" is the key question.
- **Grilling (HITL).** Use conversation for the default case. Always invoke the `/grilling` and `/domain-modeling` skills.
- **Task (HITL or AFK).** Use manual work that must happen before a _decision_ can be made. There is nothing to decide, prototype, or research, but the discussion is blocked until the task is done. Examples include signing up for a service so its API can be judged, provisioning access, or moving data so its shape can be seen. This is the one type that _does_ rather than decides. It earns its place by unblocking a decision, not by delivering the destination. The agent drives it alone where it can (AFK); otherwise it hands the human a precise checklist (HITL). Resolve it when the work is done. The answer records what was done and any facts that later tickets depend on, such as credential locations, new URLs, or row counts.

## Fog of war

The map is _deliberately_ incomplete. Don't chart what you can't yet see. Beyond the live tickets lies the **fog of war**, the dim view of decisions and investigations you can tell are coming but can't yet pin down because they depend on open questions. Resolving a ticket clears the fog ahead of it and turns whatever is now specifiable into fresh tickets. Continue one ticket at a time until the way to the destination is clear and no tickets remain.

Write that dim view in the map's **Not yet specified** section: the suspected question or area to revisit later. It is the undiscovered frontier _toward_ the destination. Everything here is in scope, but not sharp enough to ticket. Write as loosely or as fully as the view allows; it also shows collaborators where the effort is headed.

**Fog or ticket?** The test is whether you can state the question precisely now. It is _not_ whether you can answer it now.

- Create a **ticket** when the question is already sharp, even if it's blocked and you can't act on it yet.
- Use **Not yet specified** when you can't yet phrase the question that sharply. Don't pre-slice the fog into ticket-sized pieces. It is coarser than a ticket, and one patch may become several tickets, or none, once the frontier reaches it.

**Not yet specified** excludes what's already decided (Decisions so far), what's already a live ticket, and what's out of scope (the next section).

## Out of scope

Fog only gathers _toward_ the destination. The destination fixes the scope. Work beyond it is **out of scope**, not fog, and does not belong in **Not yet specified**. Put work you've consciously ruled out of _this_ effort in the map's **Out of scope** section. Scope, not sharpness, puts it there.

Out-of-scope work never graduates. The frontier stops at the destination. Such work returns only if the destination is redrawn, and then as a fresh effort, not a resumption.

Ruling something out of scope is a scoping act, not a step on the route. When an existing ticket turns out to sit past the destination, whether it was mis-scoped while charting or exposed by a resolution, **close it**. A closed ticket is unambiguously off the frontier. Leave one line in the **Out of scope** section with the gist, the reason it is out of scope, and a link to the closed ticket. Keep it out of **Decisions so far**, which records the route actually walked. A scope boundary isn't a step on that route.

## Invocation

There are two modes. In either mode, **never resolve more than one ticket per session**, except for research tickets.

### Chart the map

User invokes with a loose idea.

1. **Name the destination.** Run a `/grilling` and `/domain-modeling` session to pin down what this map is finding its way to: the spec, decision, or change. The destination fixes the scope, so settle it first.
2. **Map the frontier.** Grill again, **breadth-first** this time. Fan out across the whole space rather than going deep on one thread. Surface the open decisions and the first steps that are available now. **If this surfaces no fog**, the way to the destination is already clear and the whole journey fits in one session. You don't need a map. Stop and ask the user how they'd like to proceed.
3. **Create the map** (label `wayfinder:map`): Destination and Notes filled in, Decisions-so-far empty, the fog sketched into **Not yet specified**.
4. **Create the tickets you can specify now** as child issues of the map. Then wire blocking edges in a **second pass** because issues need ids before they can reference each other. Wiring sorts them into the frontier and the blocked. Everything you can't yet specify stays in the fog, in the **Not yet specified** section.
5. **Fire the research subagents.** For each `research` ticket you just created, spin up a `/research` subagent to resolve it in parallel, capturing its findings on a throwaway `research/<name>` branch with a context pointer from the ticket.
6. Stop. Charting is one session's work; it hand-resolves nothing.

### Work through the map

The user invokes with a map (URL or number). A ticket is **optional**. Without one, you pick the next decision, not the user.

1. Load the **map**, which is the low-resolution view. Don't load every ticket body.
2. Choose the ticket. If the user named one, use it. Otherwise take the first frontier ticket in order. **Claim it**: assign it to yourself before any work.
3. Resolve it and **zoom as needed**. Fetch the full body of any related or closed ticket on demand. Invoke the skills named in the `## Notes` block. If in doubt, use `/grilling` and `/domain-modeling`.
4. Record the resolution: post the answer as a **resolution comment**, **close** the issue, and **append a context pointer** to the map's Decisions-so-far.
5. Add newly surfaced tickets using create-then-wire. Graduate any fog the answer has made specifiable, clearing each graduated patch from **Not yet specified** so it lives only as its new ticket. If the answer reveals that this or another ticket sits beyond the destination, **rule it out of scope** rather than resolving it on the route. If the decision invalidates other parts of the map, update or delete those tickets.

The user may run unblocked tickets in parallel, so expect other sessions to be editing the tracker concurrently.
