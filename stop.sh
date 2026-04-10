#!/bin/bash

# ── Stop Local AI ─────────────────────────────────

echo ""
echo "🛑 Stopping Local AI..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

docker compose down 2>/dev/null || docker-compose down

# Stop MLX-LM server
if [ -f /tmp/mlx-lm-server.pid ]; then
    kill "$(cat /tmp/mlx-lm-server.pid)" 2>/dev/null || true
    rm -f /tmp/mlx-lm-server.pid
fi

echo "✓ Stopped."
echo ""
