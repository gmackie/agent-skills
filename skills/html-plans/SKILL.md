---
name: html-plans
description: Author plans, initial proposals, research findings, and decision comparisons as themed HTML. Prefer inline T3 Code renders with live theme tokens, Mermaid, and lightweight visualizations; retain static postplan publishing for shareable plans. Use for substantive planning and research deliverables, not routine status messages. Plans are HTML files, not Markdown files. Use read-plans to fetch published plans.
metadata:
  tags: "documentation,planning"
  groups: "plans"
  invocation: "model"
---

# HTML plans

Bias toward HTML rendered directly in T3 Code for initial proposals, research findings, comparisons, and plans. Make evidence and decisions easy to inspect with compact visualizations and progressive disclosure. Short answers and routine progress updates can stay plain text; a report does not need a dashboard just to use HTML.

## Choose the delivery surface

- **T3 Code by default:** author a complete HTML document, preview it with `html_preview`, then publish it into the current thread with `html_render`. Read [references/t3-rendering.md](references/t3-rendering.md) for the tool contract, layout, live theme tokens, and visualization guidance. Start from [references/t3-template.html](references/t3-template.html).
- **Postplan for a durable public link:** publish when requested, when sharing outside the thread is useful, or when updating an already published plan. Initial drafts and research do not require an upload. Export a static version using the postplan workflow below.
- **Without T3 tools:** save the HTML and share its file link, or publish a suitable static plan to postplan. A fenced HTML code block or file link alone is not a T3 render. Do not claim a render or preview succeeded unless the tool succeeded.

Keep a source HTML file for plans that will be revised: `docs/plans/<yyyy-mm-dd>-<slug>.html`, or a temporary directory for uncommitted proposals and research. Edit that source for subsequent renders. Keep interactive source and static export separate when export would discard behavior.

## Content and visualizations

Lead with the recommendation or finding, then the evidence, tradeoffs, and open decisions. Distinguish measured results from estimates and hypotheses; cite sources next to findings. Use compact charts for quantitative comparisons, Mermaid for architecture and flows, and tables for exact values. Add interaction when it helps explore the evidence, such as filtering alternatives or changing scenario assumptions. Prefer lightweight libraries and focused HTML/CSS/SVG over an application scaffold.

Scale the structure to the deliverable:

- **Proposal:** problem, options, recommendation, tradeoffs, open decisions.
- **Research findings:** findings, evidence and source links, uncertainty, implications, next steps.
- **Implementation plan:** title and status (`.badge`), date/repo/branch/author (`.meta`), Overview, Goals & Non-goals, phased `<h2>` sections, Risks & Mitigations, Verification, Open Questions. Phase task tables use **Task / Files / Verification / Status** so read-plans can recover them.

Use `<details>` for depth. Do not invent metrics, estimates, phase tables, or decorative stat tiles to fill a template. Keep Mermaid source recoverable in `<details class="mermaid-source"><summary>Diagram source</summary><pre>…</pre></details>` beside an embedded diagram, with HTML-escaped source text.

## Mermaid

T3 supports native Mermaid in chat: a `mermaid` fence is appropriate when the diagram stands on its own alongside an HTML render. Native chat rendering does not imply that raw Mermaid text inside arbitrary HTML is automatically rendered. For a diagram inside the HTML page, initialize Mermaid there or inline an SVG. Follow the T3 rendering reference for runtime theming.

For **postplan**, render Mermaid to SVG at authoring time because scripts cannot run:

```sh
npx -y -p @mermaid-js/mermaid-cli mmdc -i arch.mmd -o arch.svg -b transparent -I plan-arch
```

Use a unique `-I` ID per diagram. Inline the full SVG inside `<figure class="diagram">`, preserve the source disclosure immediately after it, and remove temporary rendering files. Choose a readable theme or a contrasting diagram surface.

## Static postplan export

[references/plan-template.html](references/plan-template.html) is the standalone static template, not the T3 inline template. Standalone exports may have their own typography and header, but must remain readable without T3's injected theme. Resolve theme colors into export CSS or provide fallbacks.

Postplan serves pages with `script-src 'none'`. These constraints apply to the export, not to T3 renders:

- Replace interactive charts and diagrams with inline SVG, data-URI images, or semantic tables. Essential findings must remain visible without JavaScript.
- Remove scripts and event handlers. Upload rejects external scripts, module scripts, inline event handlers, `javascript:` URLs, forms, iframe/embed/object, and meta-refresh.
- Use one inline style block; no external stylesheets, fonts, or images. System fonts and embedded data URIs work.
- Preserve headings, task/status tables, source citations, and Mermaid source disclosures.

Preview the static export with scripts disabled, then upload:

```sh
npx postplan upload docs/plans/2026-10-06-my-plan.html --description "Short label for the dashboard"
```

The first upload creates a draft; re-uploading the **same file path** publishes a new version at the **same URL** (mapping in `~/.postplan`). Re-upload after edits to a published plan and share the returned URL. `--description` is needed only for the initial label or to change it. History is available at `/v/<n>/raw`; `npx postplan list` lists drafts after `npx postplan auth login`. Use **read-plans** to fetch existing published plans.

Uploads are **public by default**. Exclude secrets, credentials, internal hostnames, and customer data. Keep sensitive material local or within an appropriate existing thread instead of uploading it publicly; explain the choice and share the local file when needed.

## Check before delivery

Check content accuracy, links, narrow-screen layout, contrast, and accessible labels. For T3, inspect `html_preview` output and console messages in light and dark mode, including a phone width, before `html_render`. For static exports, check that all essential content survives without scripts or remote resources. Keep the final reply brief and avoid repeating the rendered document.
