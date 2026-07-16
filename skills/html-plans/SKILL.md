---
name: html-plans
description: Author plans (implementation plans, migration plans, design docs, PRD-style plans) as rich, self-contained HTML documents and publish them with `npx postplan upload`. Use whenever creating or updating any plan — plans are never markdown files. Write the plan as a single HTML file, upload it with postplan, and share the returned URL.
---

# HTML Plans

Plans are single, self-contained HTML files published via [postplan](https://postplan.dev). Never write a plan as a markdown file.

## Workflow

1. **Author** the plan as one HTML file.
   - Save to `docs/plans/<yyyy-mm-dd>-<slug>.html` in the repo. If the plan shouldn't be committed, use a temp directory instead.
   - Start from [references/plan-template.html](references/plan-template.html) — copy it and replace the content, keeping the structure and styles.
2. **Upload**:
   ```sh
   npx postplan upload docs/plans/2026-07-16-my-plan.html --description "Short label for the dashboard"
   ```
   - The first upload of a file path creates a draft; re-uploading the **same path** publishes a new version at the **same URL** (mapping stored in `~/.postplan`). Always re-upload after editing a plan.
   - The CLI prints a public URL and a `Raw HTML` URL. Both serve the exact bytes.
3. **Share**: give the user the public URL (and mention the raw URL is agent/curl-friendly). Do not paste the whole plan into chat — summarize and link.

## Hard constraints (uploads are rejected otherwise)

Postplan validates HTML at upload time and serves it with `script-src 'none'`. Therefore:

- **No JavaScript reliance.** Inline classic `<script>` is technically accepted but never executes in the browser — write plans that need zero JS.
- **Rejected at upload:** external `<script src>`, module scripts, inline event handlers (`onclick=` etc.), `javascript:` URLs, `<form>`, `<iframe>`/`<embed>`/`<object>`, meta-refresh redirects.
- **Self-contained:** one inline `<style>` block; no external stylesheets, fonts, or trackers. Prefer no images; use data URIs if one is essential. Mermaid/chart output must be inlined as SVG.
- Use `<details>/<summary>` for collapsible sections — it works without JS.

## Privacy

Uploads are **public by default**. Never include secrets, credentials, API keys, internal hostnames, or customer data in a plan. If the plan is inherently sensitive, keep the HTML file local, tell the user why it wasn't uploaded, and share the file path instead.

## What a good plan contains

- Header: title, date, repo + branch, author/agent, status badge (Draft / In review / Approved / Done).
- Overview: 2–3 sentences on the problem and the approach.
- Goals and non-goals.
- Phased task breakdown — each phase a section with a task table (task, files touched, verification, status).
- Risks & mitigations table.
- Verification plan: how we'll know it worked.
- Open questions.

Keep prose tight; the richness comes from structure (tables, badges, collapsible detail), not word count.

## Versioning

- Edit the same file and re-upload — the URL stays stable, viewers see the latest version, and history is kept (`/v/<n>/raw`).
- Use `--description` only on first upload or when the label should change; omitting it preserves the existing one.
- `npx postplan list` shows your published drafts (requires `npx postplan auth login` once).
