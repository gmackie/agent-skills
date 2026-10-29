---
name: writing-for-agents
description: Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
license: MIT
metadata:
  tags: "agent-instructions,context,skills"
  groups: "agent-authoring"
  invocation: "model"
  source: "https://github.com/mattpocock/skills@84fdeffd12f2ee307994d1eb6feb48173b6e0502:skills/productivity/writing-for-agents"
---

Use this reference when writing any document an agent consumes, including a skill, an `AGENTS.md` or `CLAUDE.md`, or a document reached by a pointer. The packaging differs, but the writing does not. The same levers make the agent follow a predictable _process_ on every run without forcing the same output.

When the document you're writing is a skill, read [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) for frontmatter, invocation choice, and router skills.

## Context pointers

A **context pointer** is a reference held in the agent's context that names some out-of-context material and encodes the condition for reaching it. A skill's description is one; a line in `AGENTS.md` naming a document is the same object. The pointer's _wording_, not its target, decides when the agent reaches the material and how reliably. A must-have target behind a weakly worded pointer is a variance bug. Sharpen the wording first, and inline the material only if sharpening fails.

A pointer does two jobs. It states what the material is and lists the **branches** that should trigger reaching it. A branch is a distinct case the document handles, so different runs take different paths through it. Every word of an always-loaded pointer costs on every turn, so prune it even harder than the body:

- **Front-load the leading word.** The pointer is where it does its triggering work.
- **One trigger per branch.** Synonyms that rename a single branch are one branch written twice; collapse them and keep only genuinely distinct branches.
- **Cut identity the body already carries.**

## The two loads

Every document and pointer you add spends one of two budgets:

- **Context load.** The cost of always-loaded material in the agent's window. An `AGENTS.md` line, a skill description, or anything else in context every turn spends tokens and attention whether or not it fires.
- **Cognitive load.** The cost to the human of knowing which documents exist and when to reach for each. The human is the index. This is not a cost to minimise; it is the price of human agency. Spend it where human judgement matters and remove it where it does not.

Material reached only through a pointer escapes context load at the price of the pointer's own line; material with no pointer at all rides entirely on cognitive load.

## Information hierarchy

A document is built from two content types that mix freely. **Steps** are the ordered actions the agent performs. **Reference** contains definitions, rules, and facts consulted on demand. A document may contain only steps, only reference, or both. The core decision is where each piece sits on the **information hierarchy**, a ladder ranked by how soon the agent needs the material:

1. **In-file step.** The primary tier: what the agent does, in order.
2. **In-file reference.** Consulted on demand. This is often a legitimately flat peer set, such as every rule of a review on one rung. That is a fine arrangement, not a smell.
3. **Disclosed reference.** Pushed into a separate file, reached by a context pointer, and loaded only when the pointer fires. This can be a sibling file in the same folder or an external reference that lives anywhere and any document can point to.

Push too little down and the top bloats; push too much and you hide material the agent actually needs. That tension is the whole decision.

**Progressive disclosure** moves material down the ladder, out of the main file and behind a pointer, so the top stays legible. Its primary purpose is to protect the hierarchy, not to optimize tokens. Branching is the cleanest disclosure test: inline what every branch needs, and put behind a pointer what only some branches reach. When a document has steps, in-file reference that should be disclosed buries them. Whether the agent attends to them becomes a coin flip, which affects variance as well as legibility.

**Co-location** is the within-file companion. The ladder decides _how far down_ a piece sits; co-location decides _what sits beside it_ once there. Keep a concept's definition, rules, and caveats under one heading instead of scattering them. Reading one part then brings its neighbours with it. The document should read like documentation written for the agent. Grouped material does; scattered material does not. This differs from duplication, which repeats one meaning in two places. Scattering fragments one meaning across many places.

**Sprawl** is the failure mode here: a document simply too long, even when every line is live and unique. Attention thins across the excess, and every extra line is one more to keep relevant. The cure is the ladder: disclose reference behind pointers, and split by branch or sequence so each path carries only what it needs.

## Steps and completion criteria

Every step ends on a **completion criterion**, which tells the agent when the work is done. Two properties make it useful:

- **Clarity.** Can the agent tell done from not done? A vague bound such as "understanding reached" invites **premature completion**. The agent ends the step before it is genuinely done as its attention slips toward _being done_. The visible steps still ahead are the **post-completion steps**. They supply the pull; the criterion's clarity supplies the resistance. Defend in order. **Sharpen the bound first** because that is local and cheap. Only if the bound is irreducibly fuzzy _and_ you observe the rush should you hide the later steps by splitting the sequence. Hiding works only across a real context boundary, such as a handoff or subagent dispatch. An inline call leaves the later steps in context and clears nothing.
- **Demand.** How much the criterion requires. "Every modified model accounted for" forces thorough work where "produce a change list" does not. Demand drives **legwork**, the digging the agent does within the work that is latent in the wording rather than written as a separate step. It is not step-bound. "Every rule applied" binds a body of flat reference just as "every step done" binds a sequence. This is how an all-reference document still carries an exhaustiveness bar.

The strongest criteria are both checkable and exhaustive.

## When to split

Splitting one document into two spends one of the two loads, so split only when the cut earns it:

- **By sequence.** Split a run of steps where the post-completion steps tempt the agent to rush the one in front of it. Keeping them out of view drives more legwork on the current task. Beware the reverse: merging sequences exposes each step's later steps to what follows, inviting premature completion.
- **By invocation.** Skill-specific: see [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Leading words

A **leading word** is a compact concept that already lives in the model's pretraining and that the agent thinks with while running the document, such as _lesson_, _fog of war_, or _tracer bullets_. Repeated as a token, never as a sentence, it accumulates a distributed definition and anchors a whole region of behaviour in few tokens by recruiting priors the model already holds. You can coin your own if you define it clearly, but a made-up word recruits no priors. You pay in definition tokens for what a pretrained word gives free, so reach for an existing word first.

It anchors twice. In the body, _execution_: the agent reaches for the same behaviour every time the word appears, and inside flat reference it focuses attention on a class of thing to look for. In a pointer, _invocation_: when the same word lives in your prompts, your docs, and your codebase, the agent links that shared language to the material and reaches it more reliably.

Hunt for opportunities to refactor with leading words. A triad spelled out at three sites or a pointer spending a sentence to gesture at one idea can collapse into a single token:

- "fast, deterministic, low-overhead" → _tight_ (a _tight_ loop).
- "a loop you believe in" → _red_. A fuzzy gate becomes a binary observable state (the loop goes _red_ on the bug, or it doesn't).

You gain fewer tokens and a sharper hook for the agent's thinking. Assume every document carries restatements that leading words can retire. Go find them.

**Negation** is the failure mode beside this lever. Steering by prohibition drags the forbidden behaviour into context and makes it _more_ available, not less. _Don't think of an elephant_, and the elephant is all there is. The negation is a weak modifier that the strongly activated concept overruns, so the ban partly reads as an instruction to do the thing. Prompt the **positive**. State the target behaviour, such as "write one-line comments", so the banned behaviour is never spoken. A prohibition earns its place only as a hard guardrail you cannot phrase positively. Even then, pair it with the positive target so attention lands on what to do.

## Pruning

- Keep each meaning in a **single source of truth**, one authoritative place that makes a behaviour change a one-place edit. **Duplication** puts the same meaning in more than one place. It costs maintenance and tokens, and inflates a meaning's prominence on the ladder past its real rank. This is the accidental inverse of a leading word, which repeats a token on purpose but never repeats the meaning.
- The **environment** is also a source of truth. This includes `package.json` scripts, config files, the directory layout, and `--help` output. A document that restates the environment is a **cache**, a copy of a lookup that earns its load only when the lookup is expensive. Cache what the agent cannot find by looking: the unwritten convention, the reason behind a choice, or the gotcha no config reveals. Leave one-file and one-command lookups to the environment, where they cannot go stale.
- Check every line for **relevance**: does it still bear on what the document does? A line loses relevance by never bearing on the task (mere exposition, or a branch that should be disclosed) or by going stale as the behaviour or world it describes changes. Shorter documents are easier to keep relevant. Without a pruning discipline the default fate is **sediment**: stale layers that settle because adding feels safe and removing feels risky, until you must core down through them to find what is still live.
- Hunt **no-ops** sentence by sentence. An instruction the model already obeys by default spends load to say nothing. Ask whether it changes behaviour from the default. This test is model-relative, not reader-relative. Two people who disagree about a no-op disagree about the default; settle it by running the document, not by debating. When a sentence fails, delete the whole sentence instead of trimming it. The test also grades leading words. A word too weak to beat the default, such as _be thorough_ when the agent is already thorough-ish, is a no-op. The fix is a stronger word, such as _relentless_, not a different technique.
