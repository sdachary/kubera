#!/usr/bin/env bash
# Kubera start — starts server and opens browser
DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DIR"

PORT=${PORT:-3002}

if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    if ! docker compose ps 2>/dev/null | grep -q "Up"; then
        docker compose up -d 2>/dev/null
    fi
else
    if ! lsof -i :$PORT 2>/dev/null | grep -q LISTEN; then
        PORT=$PORT bundle exec rails s -p $PORT -b 0.0.0.0 > server.log 2>&1 &
    fi
fi

echo "Waiting for Kubera..."
for i in $(seq 1 30); do
    if curl -sf http://localhost:$PORT/up > /dev/null 2>&1; then
        xdg-open http://localhost:$PORT 2>/dev/null || open http://localhost:$PORT 2>/dev/null || true
        exit 0
    fi
    sleep 1
done

echo "Kubera didn't start. Check logs."
exit 1
