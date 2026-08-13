---
name: html-plans
description: Author plans (implementation plans, migration plans, design docs, PRD-style plans) as rich, themed, self-contained HTML documents with mermaid diagrams rendered to inline SVG, and publish them with `npx postplan upload`. Use whenever creating or updating any plan; plans are never markdown files. Write the plan as a single HTML file, upload it with postplan, and share the returned URL. To read a published plan, see the read-plans skill.
metadata:
  tags: "documentation,planning"
  groups: "plans"
  invocation: "model"
---

# HTML plans

Plans are single, self-contained HTML files published via [postplan](https://postplan.dev). Never write a plan as a markdown file. Companion skill: **read-plans** (fetch and act on published plans).

## Workflow

1. **Author** the plan as one HTML file.
   - Save to `docs/plans/<yyyy-mm-dd>-<slug>.html` in the repo. If the plan shouldn't be committed, use a temp directory instead.
   - Start from [references/plan-template.html](references/plan-template.html). Copy it, replace the content, then **re-theme it** (below).
2. **Upload**:
   ```sh
   npx postplan upload docs/plans/2026-07-16-my-plan.html --description "Short label for the dashboard"
   ```
   - First upload of a file path creates a draft; re-uploading the **same path** publishes a new version at the **same URL** (mapping stored in `~/.postplan`). Always re-upload after editing a plan.
3. **Share**: give the user the public URL. Don't paste the whole plan into chat; summarize and link.

## Theming: every plan gets its own look

Plans do not need to be consistent or professional-looking. Give each plan a distinct personality: pick a background treatment (gradients, CSS-only patterns, deep dark, warm paper), a font pairing, and an accent palette that fits the subject. A database migration can look like a terminal; a design doc can look like a zine. Rules:

- External fonts and stylesheets are blocked (self-contained requirement). Theme with **system font stacks** such as `Palatino, Georgia, serif`, `Futura, "Avenir Next", sans-serif`, `Menlo, monospace`, or `"Marker Felt", fantasy`. Embed a small woff2 as a data URI if a font is essential.
- Keep body text readable (contrast, ≤ ~75ch lines). Go wild on the hero, headings, and accents instead.
- Keep the **structural conventions** (below) intact so read-plans and humans can still parse any plan.

## Visually striking elements (use several per plan)

The template includes copy-paste patterns for all of these. They use pure HTML/CSS, with no JS:

- **Hero header.** Full-bleed gradient or patterned banner with the title, status badge, and meta line.
- **Stat tiles.** A row of big numbers (phases, tasks, files touched, est. effort).
- **Progress bar.** Phase completion as a segmented CSS bar.
- **Timeline.** Vertical CSS timeline for phases/milestones.
- **Diagrams.** Mermaid rendered to inline SVG (next section).
- **Callouts, badges, `<details>` disclosures** for risks, decisions, and skippable depth.

## Mermaid diagrams

Postplan serves plans with `script-src 'none'`, so mermaid **cannot render in the browser**. Render at authoring time and inline the SVG:

```sh
# one diagram per .mmd file; -I sets a unique SVG id (required when inlining >1 diagram)
npx -y -p @mermaid-js/mermaid-cli mmdc -i arch.mmd -o arch.svg -b transparent -I plan-arch
```

- Inline the full `<svg>…</svg>` into the HTML inside a `<figure class="diagram">`. Delete the intermediate files.
- Pick a mermaid theme that matches the plan theme (`-t dark|neutral|forest|default`), or place the SVG in a light card on dark plans.
- **Always keep the mermaid source** in a `<details class="mermaid-source">` immediately after the figure, in a `<pre>` block. That is how read-plans and future edits recover the diagram.

## Hard constraints (uploads are rejected otherwise)

- **No JavaScript reliance.** Scripts never execute (`script-src 'none'`). Use `<details>/<summary>` and CSS only.
- **Rejected at upload:** external `<script src>`, module scripts, inline event handlers (`onclick=` etc.), `javascript:` URLs, `<form>`, `<iframe>`/`<embed>`/`<object>`, meta-refresh.
- **Self-contained:** one inline `<style>` block; no external stylesheets, fonts, or images (data URIs are fine). Diagrams must be inline SVG.

## Privacy

Uploads are **public by default**. Never include secrets, credentials, API keys, internal hostnames, or customer data. If the plan is inherently sensitive, keep the HTML local, tell the user why it wasn't uploaded, and share the file path instead.

## Structural conventions (keep these in every theme)

- `<h1>` title with a status `<span class="badge">` (Draft / In review / Approved / Done) and a `.meta` line (date, repo @ branch, author).
- Overview, Goals & Non-goals, phased `<h2>` sections, Risks & Mitigations, Verification, Open Questions.
- Each phase has a task table with columns **Task / Files / Verification / Status**, statuses as badges.
- Deep detail lives in `<details>` blocks; diagram sources in `<details class="mermaid-source">`.

## Versioning

- Edit the same file and re-upload. The URL stays stable, and history is kept (`/v/<n>/raw`).
- `--description` only on first upload or to change the label; omitting preserves it.
- `npx postplan list` shows your published drafts (after `npx postplan auth login`).
