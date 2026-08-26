#!/bin/bash
# Start LiteLLM proxy server without Docker
# Uses the local Python installation with litellm CLI
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Master key for CLI authentication (used by `lite` CLI commands)
export LITELLM_MASTER_KEY="llm-swap-secret-key"

uv run litellm \
  --config "$SCRIPT_DIR/litellm_config.yaml" \
  --port 4000 \
  --debug
