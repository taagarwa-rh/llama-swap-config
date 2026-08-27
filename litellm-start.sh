#!/bin/bash
# Start LiteLLM proxy server without Docker
# Uses the local Python installation with litellm CLI
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Master key for CLI authentication (used by `lite` CLI commands)
export LITELLM_MASTER_KEY="llm-swap-secret-key"

if [[ $(curl -s http://localhost:4000/health) ]]; then
    echo "LiteLLM server is already running."
else
    echo "Starting LiteLLM server..."
    uv run litellm \
      --config "$SCRIPT_DIR/litellm_config.yaml" \
      --port 4000 \
      --debug > /dev/null 2>&1 &
    echo "LiteLLM server started successfully."
fi
