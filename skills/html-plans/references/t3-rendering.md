# T3 Code HTML rendering

Contract checked against [htmlRender.ts](https://github.com/pingdotgg/t3code/blob/main/packages/shared/src/htmlRender.ts) and [HTML tools](https://github.com/pingdotgg/t3code/blob/main/apps/server/src/mcp/toolkits/html/tools.ts). Prefer the live tool schema if it changes.

## Preview and render

Discover `html_preview` and `html_render` in the available T3 tools (names may have an MCP prefix). Each accepts HTML text, not a file path:

- `html_preview({html, width: 728, appearance: "dark"})` returns a screenshot, `contentHeight`, console messages, and missing images. Check light mode and a width around 390 too. If the preview browser is still installing, retry after the indicated delay.
- `html_render({html, title, height})` publishes the page as a thread attachment above the final reply. Use preview `contentHeight` clamped to 80–2000 pixels; a smaller height deliberately makes the page scroll inside the frame. Titles are limited to 200 characters and HTML input to 512,000 characters under the current schema.

Call render before the final reply. The reader already sees the page; add only information it does not contain. If the tools are absent or unavailable, share the saved artifact and state that it was not rendered in T3.

## Layout

The frame blends into the reply column: normally 728px wide, wider in expanded chat, roughly 360px on phones. Use fluid width, no horizontal padding on the outermost element, and no outer card, border, or banner title. A small heading is fine when it adds context. Inner cards, chart panels, and disclosures can have padding.

Let content determine height. Avoid `100vh` or `height: 100%` on html/body: host auto-sizing can repeatedly grow the frame. Give charts fixed pixel heights with responsive widths. Avoid page-wide horizontal scrolling; contain overflow in individual code/table regions. Use semantic headings, visible labels, keyboard-operable controls, and textual data or summaries for charts.

## Live theme tokens

T3 injects CSS custom properties on `:root` and updates them live. Consume them with `var(...)`; **do not redefine the host tokens in your own `:root` rules**, which would override theme changes. Use fallbacks at the point of use, for example `color: var(--foreground, #202124)`. Custom aliases should have a document-specific prefix.

| Role | Tokens |
| --- | --- |
| Page and muted content | `--background`, `--foreground`, `--muted`, `--muted-foreground` |
| Surfaces | `--card`, `--card-foreground`, `--popover`, `--popover-foreground`, `--secondary`, `--secondary-foreground` |
| Borders and focus | `--border`, `--input`, `--ring` |
| Solid buttons | `--primary`, `--primary-foreground` |
| Brand accent | `--accent`, `--accent-foreground`, `--accent-surface`, `--accent-surface-foreground` |
| Status | `--destructive`, `--destructive-foreground`, `--destructive-surface`, `--warning`, `--warning-foreground`, `--warning-surface`, `--success`, `--success-foreground`, `--info`, `--info-foreground` |
| Code | `--code-background`, `--code-foreground` |
| Charts | `--chart-1` through `--chart-6` |
| Typography and corners | `--font-sans`, `--font-mono`, `--radius` |

`--accent` is the brand color here, not the app's neutral hover surface. Values are complete CSS colors: use `var(--accent)`, not `hsl(var(--accent))`. The base stylesheet already sets background, text, fonts, body margin zero, and hidden page scrollbars. Let T3 handle its bootstrap, theme messages, and sizing protocol.

## Lightweight visualizations

T3 allows inline JavaScript and remote HTTP(S) resources, including CDN chart libraries. Absolute local image paths are inlined by the renderer; this does not bundle arbitrary local scripts or stylesheets. Keep document CSS and application logic inline. Pin any CDN dependency to an exact version and include only what the visualization needs.

- Use HTML/CSS or small inline SVG for simple comparisons, timelines, progress, and small charts.
- For denser quantitative plots, a focused library such as uPlot can keep the page compact. Chart.js is useful when its chart types or interactions justify it. Inline required CSS or use a pinned stylesheet supported by the T3 surface; remove those external dependencies from postplan exports.
- Use Mermaid for flows, sequences, and architecture. Prefer T3's native chat Mermaid for standalone diagrams. For embedded Mermaid, explicitly load/initialize it or pre-render SVG; keep its source separate from the generated output so re-rendering and export remain possible.
- Avoid React scaffolds and large dashboard libraries for a single report. Keep evidence and readable data visible if a dependency fails to load.

SVG/CSS can consume theme variables directly. Canvas libraries and Mermaid configuration usually need resolved colors: read `getComputedStyle(document.documentElement).getPropertyValue('--chart-1').trim()` and the relevant foreground/background tokens when drawing. Repaint when the host theme changes, for example by observing the injected `style#t3-theme` element with a `MutationObserver` and scheduling a chart update. Do not freeze colors at first load or implement a competing theme switcher. For Mermaid, retain the original source and re-render with resolved theme variables when needed.

For a public static export, render charts to SVG or embedded images and replace controls with explicit scenario descriptions or tables. Do not upload an interactive T3 document unchanged and expect its scripts to run on postplan.
