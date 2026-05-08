#!/usr/bin/env bash
# Kubera stop — stops the server
DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DIR"

if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose down
else
    PID=$(lsof -ti :${PORT:-3002} 2>/dev/null)
    if [ -n "$PID" ]; then
        kill "$PID" 2>/dev/null && echo "Kubera stopped." || echo "Failed to stop."
    else
        echo "Kubera is not running."
    fi
fi
