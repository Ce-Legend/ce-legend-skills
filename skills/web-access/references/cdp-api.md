# Local Chrome CDP API

Use this reference only when Codex's built-in `web` tools and Playwright browser are not enough, and the task needs the user's local Chrome state.

## When To Choose This Path

Choose local Chrome CDP when:

- the page must reuse the user's normal Chrome login state
- Playwright's isolated browser is insufficient
- a site behaves better in the user's everyday browser profile
- you need direct DOM or media control in the local Chrome session

Start readiness checks with:

```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/web-access/scripts/check-deps.sh"
```

If you need to actually serve the proxy inside Codex, start it in a dedicated long-running session:

```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/web-access/scripts/check-deps.sh" --start
```

The proxy listens on `http://127.0.0.1:3456` by default.

## Endpoints

### `GET /health`

Returns proxy status and Chrome connection state.

```bash
curl -s http://127.0.0.1:3456/health
```

### `GET /targets`

Lists currently open page targets.

```bash
curl -s http://127.0.0.1:3456/targets
```

### `GET /new?url=...`

Creates a new background tab and waits for initial load.

```bash
curl -s "http://127.0.0.1:3456/new?url=https://example.com"
```

### `GET /close?target=...`

Closes a tab created or targeted by the proxy.

```bash
curl -s "http://127.0.0.1:3456/close?target=TARGET_ID"
```

### `GET /navigate?target=...&url=...`

Navigates an existing target to a new URL.

```bash
curl -s "http://127.0.0.1:3456/navigate?target=TARGET_ID&url=https://example.com"
```

### `GET /back?target=...`

Navigates back in the current target.

```bash
curl -s "http://127.0.0.1:3456/back?target=TARGET_ID"
```

### `GET /info?target=...`

Returns title, URL, and `document.readyState`.

```bash
curl -s "http://127.0.0.1:3456/info?target=TARGET_ID"
```

### `POST /eval?target=...`

Runs JavaScript and returns a serializable value.

```bash
curl -s -X POST "http://127.0.0.1:3456/eval?target=TARGET_ID" -d 'document.title'
```

Guidance:

- return strings, numbers, arrays, or plain objects
- extract attributes from DOM nodes instead of returning nodes directly
- use `JSON.stringify(...)` when returning larger structured payloads

### `POST /click?target=...`

Performs `el.click()` on a CSS selector.

```bash
curl -s -X POST "http://127.0.0.1:3456/click?target=TARGET_ID" -d 'button.submit'
```

### `POST /clickAt?target=...`

Performs a real mouse click using CDP input events.

```bash
curl -s -X POST "http://127.0.0.1:3456/clickAt?target=TARGET_ID" -d 'button.upload'
```

### `POST /setFiles?target=...`

Sets local files on a file input.

```bash
curl -s -X POST "http://127.0.0.1:3456/setFiles?target=TARGET_ID" \
  -d '{"selector":"input[type=file]","files":["/path/to/file.png"]}'
```

### `GET /scroll?target=...`

Scrolls the page to trigger lazy loading or move the viewport.

```bash
curl -s "http://127.0.0.1:3456/scroll?target=TARGET_ID&direction=bottom"
```

### `GET /screenshot?target=...&file=...`

Captures a screenshot from the local Chrome page.

```bash
curl -s "http://127.0.0.1:3456/screenshot?target=TARGET_ID&file=/tmp/shot.png"
```

## Operating Notes

- Prefer creating your own background tabs instead of touching the user's existing tabs.
- Close only the tabs created for the task.
- If the content is already in the DOM, extract it with `/eval` before falling back to screenshots.
- Use `/clickAt` only when normal DOM clicking is insufficient.
- If remote debugging is not enabled, ask the user to allow it in `chrome://inspect/#remote-debugging`.
