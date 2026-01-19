# Llama Swap Config

My personal [`llama-swap`](https://github.com/mostlygeek/llama-swap) configuration.
This is meant to replace my Ollama configuration, so I use the same port (11434) for serving.

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
# Llama-swap
alias llm-start="/path/to/llama-swap-config/start.sh"
alias llm-stop="/path/to/llama-swap-config/stop.sh"
alias llm-list="/path/to/llama-swap-config/list.sh"
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
