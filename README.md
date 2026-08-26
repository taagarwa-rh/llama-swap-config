# Llama Swap Config

My personal [`llama-swap`](https://github.com/mostlygeek/llama-swap) configuration.
This is meant to replace my Ollama configuration, so I use the same port (11434) for serving.

- [System Info](#system-info)
- [Setup](#setup)
- [Usage](#usage)
- [Run your own models](#run-your-own-models)
- [LiteLLM Setup](#litellm-setup)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Proxy](#running-the-proxy)
  - [Configuration](#configuration)
  - [Thinking Block Cleanup (`strip_thinking.py`)](#thinking-block-cleanup-strip_thinkingpy)
  - [Using the Proxy](#using-the-proxy)
  - [Using the `lite` CLI](#using-the-lite-cli)
  - [Optional: Add Aliases](#optional-add-aliases)

## System Info

```sh
> system_profiler SPDisplaysDataType

Graphics/Displays:

    Apple M4 Pro:

      Chipset Model: Apple M4 Pro
      Type: GPU
      Bus: Built-In
      Total Number of Cores: 20
      Vendor: Apple (0x106b)
      Metal Support: Metal 4

```

## Setup

1. Install [`llama.cpp` with homebrew](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md#homebrew-mac-and-linux)

    ```sh
    brew install llama.cpp
    ```

1. Install [`llama-swap` with homebrew](https://github.com/mostlygeek/llama-swap?tab=readme-ov-file#homebrew-install-macoslinux)

    ```sh
    brew tap mostlygeek/llama-swap
    brew install llama-swap
    ```

## Usage

Start the llama-swap server on port 11434

```sh
chmod a+x start.sh
./start.sh
```

List available and running models (only available while server is running.)

```sh
chmod a+x list.sh
./list.sh
```

Stop the server

```sh
chmod a+x stop.sh
./stop.sh
```

I've also added the following to my `.zshrc` file to start the server from anywhere

```sh
# Llama-swap (update the path to where you cloned the repo)
LLAMA_SWAP_DIR="$HOME/path/to/llama-swap-config"
alias llm-start="$LLAMA_SWAP_DIR/start.sh"
alias llm-stop="$LLAMA_SWAP_DIR/stop.sh"
alias llm-list="$LLAMA_SWAP_DIR/list.sh"
alias llm-config="code $LLAMA_SWAP_DIR/config.yaml"
```

Which enables you to run `llm-start` to start the server, `llm-list` to list available models, and `llm-stop` to stop the server.

## Run your own models

1. Create a [configuration file](https://github.com/mostlygeek/llama-swap/blob/main/docs/configuration.md) for `llama-swap`, e.g.

    ```yaml
    models:
      gpt-oss-20b:
        cmd: llama-server --port ${PORT} -hf openai/gpt-oss-20b
    ```

    If you downloaded a model, use the path to the `.gguf` file or model folder instead

    ```yaml
    models:
      model1:
        cmd: llama-server --port ${PORT} --model /path/to/model.gguf
    ```

1. Run your model command once to test/download your model. Specify an open port in your test

    ```sh
    llama-server --port 1111 -hf openai/gpt-oss-20b
    ```

1. Run

    ```sh
    llama-swap --config path/to/config.yaml --listen localhost:8080
    ```

## LiteLLM Setup

LiteLLM proxy sits on top of llama-swap (port 11434) and adds cloud model routing (Claude via Vertex AI).

### Prerequisites

Ensure you have logged in to your Google Cloud project and the following environment variables are set:

```sh
export ANTHROPIC_VERTEX_PROJECT_ID=
```

### Installation

```sh
uv pip install 'litellm[cli,proxy,google]'
```

### Running the Proxy

Start the proxy (no Docker needed):

```sh
chmod a+x litellm-start.sh
./litellm-start.sh
```

Or run directly:

```sh
uv run litellm --config litellm_config.yaml --port 4000
```

### Configuration

Your `litellm_config.yaml` defines:
- **`qwen3.6-35b-coder`** → Routes to your local llama-swap at `localhost:11434`
- **`claude-opus-4-6`** → Routes to Vertex AI (Claude)
- **`smart-router`** → Complexity-based auto-routing between local and cloud models

### Thinking Block Cleanup (`strip_thinking.py`)

Claude models with extended thinking return "thinking blocks" in their responses. In multi-turn conversations, these blocks can end up back in the request history with their content stripped (by the client or proxy for token savings). The Anthropic API rejects empty thinking blocks with:

```
messages.N.content.0.thinking: each thinking block must contain thinking
```

This is especially common when the smart router switches between local and cloud models mid-conversation. The `strip_thinking.py` callback hooks into LiteLLM's `async_pre_call_hook` to remove only empty thinking blocks from the conversation history before sending the request — valid thinking blocks with content are preserved.

### Using the Proxy

Once running on port 4000, use it as your OpenAI-compatible endpoint:

```sh
# Test with curl
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "smart-router",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Using the `lite` CLI

The `lite` CLI requires a master key. The `--skip-verify` flag goes **after** the subcommand:

```sh
# Run Claude Code through the proxy
lite --api-key llm-swap-secret-key claude --skip-verify --model claude-opus-4-6 "Your prompt here"

# Run interactive chat
lite --api-key llm-swap-secret-key chat --skip-verify --model smart-router

# Use a specific local model
lite --api-key llm-swap-secret-key chat --skip-verify --model qwen3.6-35b-coder
```

### Optional: Add Aliases

Add these to your `~/.zshrc`:

```sh
export LITELLM_PROXY_API_KEY="llm-swap-secret-key"
alias lite-chat='lite --api-key $LITELLM_PROXY_API_KEY chat --skip-verify'
alias lite-claude='export ANTHROPIC_MODEL='smart-router'; unset CLAUDE_CODE_USE_VERTEX; unset ANTHROPIC_SMALL_FAST_MODEL; lite --api-key $LITELLM_PROXY_API_KEY claude --skip-verify'
```

Then you can use Claude Code with the `smart-router`:

```sh
lite-claude --model smart-router
```
