---
name: web-access
description: Web research and browser-operation workflow for Codex. Use when a task depends on current internet information, source verification, a specific URL, dynamic page reading, browser interaction, file upload/download flows, login-sensitive website state, or evidence-backed answers with citations. Prefer lightweight search and page reads first, then escalate to browser automation or local Chrome CDP only when the page or task requires it.
---

# Web Access

Use this skill when a request needs the live web or a real browser surface. Treat it as an investigation workflow: define the needed result, choose the cheapest credible access layer, preserve evidence, and stop when the requested outcome is verified.

## Core Workflow

1. Define the success condition.
   Decide whether the task needs a current fact, a source-linked answer, a completed web action, a downloaded artifact, a screenshot, or browser state verification.

2. Start with the lightest reliable layer.
   Use search and direct page reads for factual lookup. Use browser automation only when content is dynamic, interactive, gated by UI state, or depends on upload/download flows.

3. Escalate by evidence.
   If a page is incomplete, blocked, login-sensitive, JavaScript-rendered, or behaving differently from raw HTML, move to a browser layer instead of repeating the same failed fetch.

4. Return verifiable output.
   For research, cite sources and prefer primary material. For browser actions, report the exact completed state and any remaining uncertainty.

## Tool Selection

Prefer this order unless the user request clearly starts at a higher layer:

- Built-in web/search tools: current facts, source discovery, page reading, finance/weather/sports lookups, and citation-backed answers.
- Playwright or in-app browser tools: clicking, typing, DOM inspection, screenshots, uploads, downloads, and JavaScript-heavy pages.
- Direct HTTP tools such as `curl`: status codes, headers, meta tags, raw HTML, JSON, JSON-LD, robots, sitemap, and minimal page probes.
- Local Chrome CDP fallback: tasks requiring the user's Chrome login state, regular browser profile behavior, or pages that fail in isolated browser contexts.

## Verification Standard

- Treat search results as discovery, not proof.
- Prefer official pages, primary documents, source announcements, original datasets, and directly opened URLs.
- Use secondary reporting only when primary sources are unavailable or insufficient, and say so.
- For unstable facts such as prices, laws, schedules, product specs, company roles, package docs, or recent events, verify freshness before answering.
- Keep extracted evidence narrow: titles, dates, snippets, URLs, status, selectors, and the smallest relevant page passages.

## Browser Strategy

- Inspect visible state and DOM structure before acting.
- Prefer extracting existing page data over replaying unnecessary UI steps.
- Open separate tabs only for independent targets, and keep tab ownership clear.
- For login-sensitive tasks, never export cookies, passwords, tokens, verification codes, or private session data.
- For upload/download flows, verify the resulting page state or saved file instead of assuming success after a click.

## Local Chrome CDP

Use the CDP fallback only when needed. First check dependencies:

```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/web-access/scripts/check-deps.sh"
```

If CDP is required and not already running, start it in a long-running terminal session:

```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/web-access/scripts/check-deps.sh" --start
```

Then read [references/cdp-api.md](references/cdp-api.md) for local endpoints and request patterns.

## Site Patterns

Domain-specific notes may live under `references/site-patterns/`. When a target domain is clear, check for a matching file before exploring from scratch. To find aliases:

```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/web-access/scripts/match-site.sh" "<domain or user request>"
```

Treat site notes as hints. Update them only with verified, repeatable behavior.

## Resource Loading

- Read [references/cdp-api.md](references/cdp-api.md) only when using local Chrome CDP.
- Read `references/site-patterns/<domain>.md` only when working on that domain.
- Run scripts from `scripts/` instead of retyping their logic.
