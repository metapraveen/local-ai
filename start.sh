#!/bin/bash

# ── Local AI ──────────────────────────────────────
# Starts Ollama (native, Metal GPU) + Open WebUI (Docker)
# Access at: http://local.ai:9999
# ──────────────────────────────────────────────────

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "🤖 Starting Local AI..."
echo ""

# ── Check dependencies ────────────────────────────
if ! command -v ollama &> /dev/null; then
    echo -e "${RED}✗ Ollama not found.${NC} Install with: brew install ollama"
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

# ── Start Ollama if not running ───────────────────
if ! pgrep -x "ollama" > /dev/null; then
    echo "  Starting Ollama..."
    ollama serve &> /dev/null &
    sleep 2
fi

echo -e "${GREEN}✓ Ollama running (Metal GPU)${NC}"

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
