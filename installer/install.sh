#!/usr/bin/env bash
# Kubera Single-Repo Installer
# Usage: curl -fsSL URL | bash -s ~/kubera
set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "Kubera Installer v0.3"
echo "Installing to: $INSTALL_DIR"

# Check if directory exists
if [ -d "$INSTALL_DIR" ]; then
    echo "Directory exists, checking..."
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "Existing repo found, pulling updates..."
        cd "$INSTALL_DIR"
        git pull --depth 1
    else
        echo "Directory exists but not a git repo, backing up..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
        echo "Cloning Kubera repository..."
        git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
    fi
else
    echo "Cloning Kubera repository..."
    git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# Install dependencies (sure/ is already inside)
echo "Installing dependencies..."
cd sure
bundle install 2>&1 | tail -5
npm install 2>&1 | tail -5

# Setup database
echo "Setting up database..."
cp .env.local.example .env.local 2>/dev/null || true
bin/setup 2>&1 | tail -10

echo
echo "Installation complete!"
echo "Location: $INSTALL_DIR"
echo
echo "To start:"
echo "  cd $INSTALL_DIR/sure && bin/dev"
echo
echo "Visit: http://kubera.test (add to /etc/hosts) or http://localhost:3000"
