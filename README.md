# Local AI

A local ChatGPT alternative running entirely on your Mac. Zero cloud, zero cost, full privacy.

## Prerequisites

- **uv**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Docker**: [OrbStack](https://orbstack.dev) (recommended) or Docker Desktop

## Usage

```bash
# Start everything
./start.sh

# Start with a different model
MLX_MODEL=mlx-community/Qwen3-8B-4bit ./start.sh

# Open in browser
open http://local.ai

# Stop everything
./stop.sh
```

## What's Inside

| Component   | Runs In                 | Purpose                     |
| ----------- | ----------------------- | --------------------------- |
| MLX-LM      | Native (Apple Silicon) | LLM inference via MLX       |
| Open WebUI  | Docker                 | ChatGPT-style web interface |

## Models

The default model is `mlx-community/Qwen3-8B-4bit` — fast and great for text generation. Switch models by setting `MLX_MODEL`:

```bash
MLX_MODEL=mlx-community/Qwen3-32B-4bit ./start.sh          # Smarter, slower (48GB RAM)
MLX_MODEL=mlx-community/Qwen2.5-Coder-32B-Instruct-4bit ./start.sh  # Coding focused
MLX_MODEL=mlx-community/Qwen3-32B-8bit ./start.sh          # Higher quality (more RAM)
```

Models are downloaded from [mlx-community](https://huggingface.co/mlx-community) on HuggingFace on first use and cached in `~/.cache/huggingface/`.
