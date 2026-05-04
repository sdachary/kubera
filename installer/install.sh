#!/usr/bin/env bash
# Kubera One-Line Installer
# Usage: curl -fsSL URL | bash -s ~/kubera
#    or: curl -fsSL URL | bash -s /path/to/kubera
#    or: curl -fsSL URL | bash (installs in current dir/kubera)

set -e

# If user passes ~ or $HOME, expand to actual home path
if [[ "$1" == "~" || "$1" == "$HOME" || "$1" == "" ]]; then
    INSTALL_DIR="$HOME/kubera"
else
    # If relative path, make it absolute
    if [[ "$1" != /* ]]; then
        INSTALL_DIR="$(pwd)/$1"
    else
        INSTALL_DIR="$1"
    fi
fi

echo "Kubera Installer v0.3"
echo "Installing to: $INSTALL_DIR"

# Create directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Clone Sure repo
echo "Cloning Sure repository..."
git clone --depth 1 https://github.com/we-promise/sure.git sure 2>&1 | tail -3

# Create .env.local
echo "Creating .env.local..."
cat > sure/.env.local << 'EOF'
OPENROUTER_API_KEY=
DATABASE_URL=postgresql://localhost/kubera_development
EOF

echo
echo "Installation complete!"
echo "Location: $INSTALL_DIR"
echo
echo "Next steps:"
echo "  cd $INSTALL_DIR/sure"
echo "  bundle install && npm install"
echo "  bin/setup"
echo "  bin/dev"
echo "  Visit: http://localhost:3000"
