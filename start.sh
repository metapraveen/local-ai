#!/bin/bash

# ── Local AI ──────────────────────────────────────
# Starts MLX-LM server (native, Apple Silicon) + Open WebUI (Docker)
# Access at: http://local.ai
# ──────────────────────────────────────────────────

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MLX_MODEL="${MLX_MODEL:-mlx-community/Qwen3-8B-4bit}"
MLX_PORT=8000

echo ""
echo "🤖 Starting Local AI..."
echo ""

# ── Check dependencies ────────────────────────────
if ! command -v uv &> /dev/null; then
    echo -e "${RED}✗ uv not found.${NC} Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found.${NC} Install OrbStack or Docker Desktop."
    exit 1
fi

# ── Check /etc/hosts for local.ai ─────────────────
if ! grep -q "local.ai" /etc/hosts; then
    echo -e "${YELLOW}⚠ local.ai not in /etc/hosts. Adding it (needs sudo)...${NC}"
    echo "127.0.0.1 local.ai" | sudo tee -a /etc/hosts > /dev/null
    echo -e "${GREEN}✓ Added local.ai to /etc/hosts${NC}"
fi

# ── Install mlx-lm if needed ─────────────────────
if ! uv tool list 2>/dev/null | grep -q "mlx-lm"; then
    echo "  Installing mlx-lm..."
    uv tool install mlx-lm --python 3.11
fi

# ── Start MLX-LM server if not running ───────────
if ! lsof -i :"$MLX_PORT" -sTCP:LISTEN &> /dev/null; then
    echo "  Starting MLX-LM server (model: $MLX_MODEL)..."
    mlx_lm.server --model "$MLX_MODEL" --port "$MLX_PORT" &> /tmp/mlx-lm-server.log &
    MLX_PID=$!
    echo $MLX_PID > /tmp/mlx-lm-server.pid

    # Wait for the server to be ready
    echo -n "  Waiting for server"
    for i in $(seq 1 60); do
        if curl -s "http://localhost:$MLX_PORT/v1/models" > /dev/null 2>&1; then
            echo ""
            break
        fi
        if ! kill -0 "$MLX_PID" 2>/dev/null; then
            echo ""
            echo -e "${RED}✗ MLX-LM server exited unexpectedly. Check /tmp/mlx-lm-server.log${NC}"
            exit 1
        fi
        echo -n "."
        sleep 2
    done

    if ! curl -s "http://localhost:$MLX_PORT/v1/models" > /dev/null 2>&1; then
        echo ""
        echo -e "${RED}✗ Timed out waiting for server. Is the model downloaded?${NC}"
        echo -e "  Run: ${YELLOW}uvx --python 3.11 --from huggingface-hub hf download $MLX_MODEL${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ MLX-LM server running on port $MLX_PORT (Apple Silicon)${NC}"

# ── Start Open WebUI ──────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

docker compose up -d --pull=always 2>/dev/null || docker-compose up -d --pull=always

echo -e "${GREEN}✓ Open WebUI running${NC}"

echo ""
echo "──────────────────────────────────────"
echo -e "  🚀 ${GREEN}http://local.ai${NC}"
echo "──────────────────────────────────────"
echo ""
