#!/bin/bash
# Kubera Installer - Single command: curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash

set -e

KUBERA_DIR="$HOME/.kubera"
REPO_URL="https://github.com/sdachary/kubera.git"

echo "🚀 Starting Kubera installation..."

if [ -d "$KUBERA_DIR" ]; then
    echo "✅ Kubera already installed at $KUBERA_DIR"
    cd "$KUBERA_DIR"
    ruby tui/main.rb
    exit 0
fi

echo "📦 Installing system dependencies..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/debian_version ]; then
        sudo apt-get update -y && sudo apt-get install -y ruby ruby-dev libpq-dev postgresql nodejs git
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ruby postgresql node git 2>/dev/null || true
fi

echo "📦 Installing Ruby gems..."
gem install tty-prompt tty-table pastel --no-document 2>/dev/null || true

echo "📥 Cloning Kubera..."
git clone "$REPO_URL" "$KUBERA_DIR"
cd "$KUBERA_DIR"

ruby tui/main.rb
