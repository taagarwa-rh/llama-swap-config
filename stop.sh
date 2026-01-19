if [[ $(netstat -an | grep 11434) ]]; then
    echo "Shutting down server..."
    kill $(lsof -t -i:11434)
    echo "Server successfully shut down."
else
    echo "Server is not running."
fi
