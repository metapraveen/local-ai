#!/bin/bash

# ── Stop Local AI ─────────────────────────────────

echo ""
echo "🛑 Stopping Local AI..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

docker compose down 2>/dev/null || docker-compose down
pkill ollama 2>/dev/null || true

echo "✓ Stopped."
echo ""
