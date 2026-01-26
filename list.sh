if [[ $(curl -s http://localhost:11434/v1/models) ]]; then

    echo "=== Available ==="
    curl -s http://localhost:11434/v1/models | jq -r '.data.[].id'

    echo "\n=== Running ==="
    curl -s http://localhost:11434/running | jq -r '.running.[].model'

else
    echo "Server is not running. Please start server with 'llm-start'"
fi