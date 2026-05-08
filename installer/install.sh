#!/usr/bin/env bash
# Kubera Zero-Config Installer
# Usage: curl -fsSL URL | bash -s ~/kubera

set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "🚀 Kubera Zero-Config Installer"
echo "==============================="
echo "Installing to: $INSTALL_DIR"

# Check for git
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed. Please install git and try again."
    exit 1
fi

# Handle existing directory
if [ -d "$INSTALL_DIR" ]; then
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "🔄 Existing repo found, updating..."
        cd "$INSTALL_DIR"
        git fetch --depth 1 origin 2>/dev/null
        git reset --hard origin/main 2>/dev/null || git pull --depth 1
    else
        echo "📦 Backing up existing directory..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
        echo "📥 Cloning Kubera repository..."
        git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
else
    echo "📥 Cloning Kubera repository..."
    git clone --depth 1 https://github.com/sdachary/kubera.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Zero-config setup
echo "⚙️ Starting zero-config setup..."

# Check for Ruby
if ! command -v ruby &> /dev/null; then
    echo "❌ Error: Ruby is not installed. Please install Ruby and try again."
    exit 1
fi

# Check for Node/NPM
if ! command -v npm &> /dev/null; then
    echo "❌ Error: NPM is not installed. Please install Node.js and NPM and try again."
    exit 1
fi

# Install bundler if missing
if ! command -v bundle &> /dev/null; then
    echo "💎 Installing Bundler..."
    gem install bundler --conservative 2>&1 | tail -3
fi

echo "💎 Installing Ruby dependencies..."
if ! bundle install 2>&1 | tail -10; then
    echo "❌ Ruby dependency installation failed."
    echo "Try running 'bundle install' manually in $INSTALL_DIR"
    echo "Or use Docker: cd $INSTALL_DIR && docker compose up -d"
    exit 1
fi

echo "📦 Installing Node dependencies..."
npm install 2>&1 | tail -5

# Run application setup
echo "🛠️ Running bin/setup..."
chmod +x bin/setup
if ! bin/setup 2>&1; then
    echo "⚠️  Setup completed with warnings (continuing anyway)."
fi

echo "📡 Starting server..."
# Start server in background
PORT=3000 bundle exec rails s > server.log 2>&1 &
SERVER_PID=$!

# Wait for server ready
echo "⏳ Waiting for server to be ready..."
MAX_RETRIES=60
RETRY_COUNT=0
until curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null | grep -q "200\|302\|401\|404\|500"; do
    RETRY_COUNT=$((RETRY_COUNT+1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo
        echo "❌ Server failed to start within 60 seconds."
        echo "Check $INSTALL_DIR/server.log for details."
        exit 1
    fi
    printf "."
    sleep 1
done

echo
echo "✅ Installation complete!"
echo "--------------------------------"
echo "📍 Location: $INSTALL_DIR"
echo "🔥 Server is running (PID: $SERVER_PID)"
echo "🔗 URL: http://localhost:3000"
echo "--------------------------------"
echo
echo "📝 To view logs: tail -f $INSTALL_DIR/server.log"
echo "🛑 To stop: kill $SERVER_PID"
echo
echo "💰 === Kubera Financial Guide ==="
echo "1️⃣ Create your account at http://localhost:3000"
echo "2️⃣ Add your liabilities (Mortgage, Loans, Credit Cards)"
echo "3️⃣ Use the AI Payoff Plan to optimize your debt reduction"
echo "4️⃣ Plan your future with the SIP (Systematic Investment Plan) tool"
echo "5️⃣ Track your transition from Debt to Financial Freedom!"
echo "==============================="
