# Local AI

A local ChatGPT alternative running entirely on your Mac. Zero cloud, zero cost, full privacy.

## Prerequisites

- **Ollama**: `brew install ollama`
- **Docker**: [OrbStack](https://orbstack.dev) (recommended) or Docker Desktop

## Usage

```bash
# Start everything
./start.sh

# Open in browser
open http://local.ai

# Stop everything
./stop.sh
```

## What's Inside

| Component   | Runs In        | Purpose                        |
| ----------- | -------------- | ------------------------------ |
| Ollama      | Native (Metal) | LLM inference with GPU         |
| Open WebUI  | Docker         | ChatGPT-style web interface    |

## Models

The default model is `qwen3:32b` (best for 48GB RAM). To add more:

```bash
ollama pull qwen3:8b            # Fast, lightweight
ollama pull qwen2.5-coder:32b   # Coding focused
ollama pull llama3.3:70b        # Max quality (tight fit on 48GB)
```

All pulled models appear automatically in the Open WebUI model dropdown.
