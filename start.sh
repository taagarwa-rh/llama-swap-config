if [[ $(netstat -an | grep 11434) ]]; then
    echo "Server is already running."
else
    echo "Starting server..."
    llama-swap --config /Users/taagarwa/Documents/Projects/llama-swap-config/config.yaml --listen localhost:11434 > /dev/null 2>&1 &
    echo "Server started successfully."
fi
open "http://localhost:11434/ui/"