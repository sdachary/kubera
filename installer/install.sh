#!/usr/bin/env bash
# Kubera Single-Repo Installer
# Usage: curl -fsSL URL | bash -s ~/kubera

set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "Kubera Installer v0.3"
echo "Installing to: $INSTALL_DIR"

# If exists, update in place
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Existing repo found, updating..."
    cd "$INSTALL_DIR"
    git fetch --depth 1 origin 2>/dev/null
    git reset --hard origin/main 2>/dev/null || git pull --depth 1
else
    # If exists but not git repo, backup and clone fresh
    if [ -d "$INSTALL_DIR" ]; then
        echo "Backing up existing directory..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
    fi
    echo "Cloning Kubera repository..."
    git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Install dependencies (sure/ is already inside)
echo "Installing dependencies..."
cd "$INSTALL_DIR/sure"
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
echo
echo "=== Quick Financial Guide ==="
echo "1. Create account at http://kubera.test"
echo "2. Add your debts (Home Loan, Car Loan, etc.)"
echo "3. See AI-powered payoff plan (Avalanche/Snowball)"
echo "4. Setup SIP planner for passive income"
echo "5. Track your journey: Debt → Zero → Wealth"
