#!/usr/bin/env bash
# Kubera Uninstaller — removes desktop shortcut and guides PWA removal
set -e

INSTALL_DIR="${1:-$HOME/kubera}"

echo "============================================"
echo "  Kubera Uninstall"
echo "============================================"

# Remove .desktop shortcut from XDG applications menu
DESKTOP_FILE="$HOME/.local/share/applications/kubera.desktop"
if [ -f "$DESKTOP_FILE" ]; then
  rm "$DESKTOP_FILE"
  echo "  Removed desktop shortcut."

  if command -v xdg-desktop-menu &>/dev/null; then
    xdg-desktop-menu uninstall kubera.desktop 2>/dev/null || true
  fi
  echo "  Desktop shortcut removed from application menu."
else
  echo "  No desktop shortcut found."
fi

echo ""
echo "  Desktop icon removed."
echo ""
echo "  To remove the PWA app icon (installed via Chrome/Edge):"
echo "    Chrome/Edge: chrome://apps → right-click Kubera → Remove"
echo "    Or: Settings → Apps → Manage apps → Kubera → Uninstall"
echo ""
echo "  PWA cache cleared on next browser restart."
echo "  Done."
