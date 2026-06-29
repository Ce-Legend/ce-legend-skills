#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/web-access"
PROXY_PORT="${CDP_PROXY_PORT:-3456}"
PROXY_HEALTH_URL="http://127.0.0.1:${PROXY_PORT}/health"
MODE="${1:-check}"

if command -v node >/dev/null 2>&1; then
  NODE_VER="$(node --version 2>/dev/null)"
  NODE_MAJOR="$(printf '%s' "$NODE_VER" | sed 's/^v//' | cut -d. -f1)"
  if [ "${NODE_MAJOR:-0}" -ge 22 ] 2>/dev/null; then
    echo "node: ok (${NODE_VER})"
  else
    echo "node: warn (${NODE_VER}, 建议升级到 22+)"
  fi
else
  echo "node: missing - 请先安装 Node.js 22+"
  exit 1
fi

health="$(curl -fsS --connect-timeout 2 "${PROXY_HEALTH_URL}" 2>/dev/null || true)"
if printf '%s' "$health" | grep -q '"connected":true'; then
  echo "proxy: ready"
  exit 0
fi

if [ "$MODE" = "--start" ]; then
  echo "proxy: starting in foreground on port ${PROXY_PORT}"
  exec node "${SKILL_DIR}/scripts/cdp-proxy.mjs"
fi

if printf '%s' "$health" | grep -q '"status":"ok"'; then
  echo "proxy: running but not connected"
else
  echo "proxy: not running"
fi

echo "chrome: 请在 Chrome 打开 chrome://inspect/#remote-debugging，并允许当前浏览器实例的远程调试"
echo "hint: 在 Codex 里如需本地 CDP，请开一个长驻会话执行：bash ${SKILL_DIR}/scripts/check-deps.sh --start"
exit 1
