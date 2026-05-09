#!/usr/bin/env bash
# Kubera Uninstaller — removes desktop shortcut, stops Docker, cleans up
set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "============================================"
echo "  Kubera Uninstall"
echo "============================================"

# Stop Docker containers if running
if [ -f "$INSTALL_DIR/compose.yml" ]; then
  echo "  Stopping Docker containers..."
  cd "$INSTALL_DIR"
  docker compose down 2>/dev/null && echo "  Docker containers stopped." || echo "  No running containers."
fi

# Remove .desktop shortcut from XDG applications menu
DESKTOP_FILE="$HOME/.local/share/applications/kubera.desktop"
if [ -f "$DESKTOP_FILE" ]; then
  rm "$DESKTOP_FILE"

  if command -v xdg-desktop-menu &>/dev/null; then
    xdg-desktop-menu uninstall kubera.desktop 2>/dev/null || true
  fi
  echo "  Desktop shortcut removed from application menu."
else
  echo "  No desktop shortcut found."
fi

# Remove install directory
if [ -d "$INSTALL_DIR" ]; then
  echo ""
  echo "  Delete the installation folder? (y/n)"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    rm -rf "$INSTALL_DIR"
    echo "  Installation folder deleted."
  else
    echo "  Skipped. Folder kept at: $INSTALL_DIR"
  fi
fi

echo ""
echo "  To remove the PWA app icon (installed via Chrome/Edge):"
echo "    Chrome/Edge: chrome://apps → right-click Kubera → Remove"
echo "    Or: Settings → Apps → Manage apps → Kubera → Uninstall"
echo ""
echo "  Done."
