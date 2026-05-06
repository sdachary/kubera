#!/usr/bin/env bash
# Kubera Zero-Config Installer
# Usage: curl -fsSL URL | bash -s ~/kubera

set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "Kubera Installer v0.5"
echo "Installing to: $INSTALL_DIR"

# Handle existing directory
if [ -d "$INSTALL_DIR" ]; then
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "Existing repo found, updating..."
        cd "$INSTALL_DIR"
        git fetch --depth 1 origin 2>/dev/null
        git reset --hard origin/main 2>/dev/null || git pull --depth 1
    else
        echo "Backing up existing directory..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
        echo "Cloning Kubera repository..."
        git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
else
    echo "Cloning Kubera repository..."
    git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Zero-config setup
echo "Starting zero-config setup..."

# Install dependencies (Required before bin/setup in some environments)
echo "Installing Ruby dependencies..."
bundle install 2>&1 | tail -5

echo "Installing Node dependencies..."
npm install 2>&1 | tail -5

# Run application setup
echo "Running bin/setup..."
bin/setup 2>&1 | tail -10

echo "Starting server..."
# Start server in background
PORT=3000 bundle exec rails s > server.log 2>&1 &
SERVER_PID=$!

# Wait a few seconds for the server to start
sleep 5

echo
echo "Installation complete!"
echo "Location: $INSTALL_DIR"
echo "Server is running (PID: $SERVER_PID)"
echo
echo "Visit: http://localhost:3000"
echo
echo "To view logs: tail -f $INSTALL_DIR/server.log"
echo "To stop: kill $SERVER_PID"

echo
echo "=== Quick Financial Guide ==="
echo "1. Create account at http://localhost:3000"
echo "2. Add your debts (Home Loan, Car Loan, etc.)"
echo "3. See AI-powered payoff plan"
echo "4. Setup SIP planner for passive income"
echo "5. Track your journey: Debt → Zero → Wealth"
