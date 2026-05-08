#!/usr/bin/env bash
# Kubera Zero-Config Installer
# Usage: curl -fsSL URL | bash

set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "🚀 Kubera Zero-Config Installer"
echo "==============================="
echo "Installing to: $INSTALL_DIR"

if ! command -v git &> /dev/null; then
    echo "❌ git is not installed."
    exit 1
fi

if [ -d "$INSTALL_DIR" ]; then
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "🔄 Updating existing installation..."
        cd "$INSTALL_DIR"
        git fetch --depth 1 origin 2>/dev/null
        git reset --hard origin/main 2>/dev/null || git pull --depth 1
    else
        echo "📦 Backing up existing directory..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
        git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
else
    git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# ──────────────────────────────────────────────
# Setup .env
# ──────────────────────────────────────────────
cp -n .env.example .env 2>/dev/null || true
if ! grep -q "SECRET_KEY_BASE=" .env 2>/dev/null || [ "$(grep 'SECRET_KEY_BASE=' .env | cut -d= -f2)" = "" ]; then
    echo >> .env
    echo "SECRET_KEY_BASE=$(openssl rand -hex 64)" >> .env
fi

# ──────────────────────────────────────────────
# Build (Docker or direct)
# ──────────────────────────────────────────────
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    echo "🔧 Building with Docker..."
    docker compose build 2>&1 | tail -3
else
    echo "🔧 Installing dependencies directly..."
    if ! command -v ruby &> /dev/null; then echo "❌ Ruby required."; exit 1; fi
    if ! command -v npm &> /dev/null; then echo "❌ NPM required."; exit 1; fi
    if ! command -v bundle &> /dev/null; then gem install bundler --conservative; hash -r; fi
    bundle install 2>&1 | tail -5
    npm install 2>&1 | tail -3
fi

# ──────────────────────────────────────────────
# Desktop shortcut
# ──────────────────────────────────────────────
echo "🖥️  Creating desktop shortcut..."

sed "s|INSTALL_DIR|$INSTALL_DIR|g" installer/kubera.desktop > /tmp/kubera.desktop

if command -v xdg-desktop-menu &> /dev/null; then
    xdg-desktop-menu install /tmp/kubera.desktop 2>/dev/null || true
fi

mkdir -p "$HOME/.local/share/applications"
cp /tmp/kubera.desktop "$HOME/.local/share/applications/kubera.desktop"

chmod +x installer/kubera-start.sh installer/kubera-stop.sh

# ──────────────────────────────────────────────
# Start
# ──────────────────────────────────────────────
echo "🚀 Starting Kubera..."
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose up -d 2>&1 | tail -3
else
    PORT=${PORT:-3002}
    PORT=$PORT bundle exec rails s -p $PORT -b 0.0.0.0 > server.log 2>&1 &
fi

echo "⏳ Waiting..."
PORT=$(grep '^PORT=' .env 2>/dev/null | cut -d= -f2)
PORT=${PORT:-3002}
for i in $(seq 1 30); do
    if curl -sf http://localhost:$PORT/up > /dev/null 2>&1; then
        echo
        echo "✅ Kubera is ready!"
        echo "📍 http://localhost:$PORT"
        echo
        echo "📱 To use as an app:"
        echo "   1. Open http://localhost:$PORT in Chrome/Edge"
        echo "   2. Click the Install icon in the address bar"
        echo "   3. Kubera launches as a standalone app"
        echo
        echo "🖥️  Desktop shortcut installed."
        echo "   Search for 'Kubera' in your app menu"
        echo "   Or run: xdg-open http://localhost:$PORT"
        echo
        echo "🛑 Stop: $INSTALL_DIR/installer/kubera-stop.sh"
        echo "   Or run: kill \$(lsof -ti :$PORT)"
        exit 0
    fi
    printf "."
    sleep 1
done

echo
echo "❌ Server didn't start. Check logs."
exit 1
