# Llama Swap Config

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

1. (Optional) Download a model from Huggingface
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
