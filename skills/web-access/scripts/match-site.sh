#!/usr/bin/env bash
set -euo pipefail

DIR="$(dirname "$0")/../references/site-patterns"
[ -d "$DIR" ] || exit 0
[ "${1:-}" != "" ] || exit 0

for f in "$DIR"/*.md; do
  [ -f "$f" ] || continue
  domain="$(basename "$f" .md)"
  aliases="$(grep '^aliases:' "$f" | sed 's/^aliases: *//; s/\[//g; s/\]//g; s/, */|/g; s/ *$//')"
  patterns="$domain"
  [ -n "$aliases" ] && patterns="$patterns|$aliases"
  if printf '%s' "$1" | grep -qiE "$patterns"; then
    echo "--- 站点经验: $domain ---"
    awk 'BEGIN{n=0} /^---$/{n++;next} n>=2{print}' "$f"
    echo ""
  fi
done

