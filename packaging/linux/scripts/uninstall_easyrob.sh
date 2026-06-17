#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
DESKTOP_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/applications/easyrob.desktop"
DESKTOP_SHORTCUT_FILE="${XDG_DESKTOP_DIR:-$HOME/Desktop}/EasyRob.desktop"

rm -rf "$INSTALL_ROOT"
rm -f "$DESKTOP_FILE"
rm -f "$DESKTOP_SHORTCUT_FILE"

echo "EasyRob was removed from $INSTALL_ROOT"
