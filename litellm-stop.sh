#!/bin/bash
if [[ $(lsof -t -i:4000) ]]; then
    echo "Shutting down LiteLLM server..."
    kill $(lsof -t -i:4000)
    echo "LiteLLM server successfully shut down."
else
    echo "LiteLLM server is not running."
fi
