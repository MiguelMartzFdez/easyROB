#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$(cd "$LINUX_ROOT/../shared" && pwd)/env.yaml"
WINDOWS_ASSETS_DIR="$(cd "$LINUX_ROOT/../windows/installer/assets" && pwd)"

INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
BIN_DIR="$INSTALL_ROOT/bin"
ENV_PREFIX="$INSTALL_ROOT/envs/easyrob"
LOG_DIR="$INSTALL_ROOT/logs"
SHARE_DIR="$INSTALL_ROOT/share"
ICON_DIR="$SHARE_DIR/icons"
ICON_SOURCE="$WINDOWS_ASSETS_DIR/Robert_icon.ico"
ICON_TARGET="$ICON_DIR/easyrob.ico"
LAUNCHER_TARGET="$BIN_DIR/easyrob"
DESKTOP_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/applications/easyrob.desktop"
MICROMAMBA_TARBALL_URL="${MICROMAMBA_TARBALL_URL:-https://micro.mamba.pm/api/micromamba/linux-64/latest}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command tar

DOWNLOAD_TOOL=""
if command -v curl >/dev/null 2>&1; then
  DOWNLOAD_TOOL="curl"
elif command -v wget >/dev/null 2>&1; then
  DOWNLOAD_TOOL="wget"
else
  echo "Either curl or wget is required to install EasyRob." >&2
  exit 1
fi

mkdir -p "$BIN_DIR" "$LOG_DIR" "$ICON_DIR" "$(dirname "$DESKTOP_FILE")"

INSTALL_LOG="$LOG_DIR/install.log"
ERROR_LOG="$LOG_DIR/install-error.log"
: > "$INSTALL_LOG"
: > "$ERROR_LOG"

log() {
  printf '%s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "$*" | tee -a "$INSTALL_LOG"
}

run_and_log() {
  log "Running: $*"
  if ! "$@" 2> >(tee -a "$ERROR_LOG" >&2) | tee -a "$INSTALL_LOG"; then
    log "Command failed: $*"
    exit 1
  fi
}

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

log "Installing EasyRob into $INSTALL_ROOT"
log "Logs: $INSTALL_LOG"
log "Downloading Micromamba bootstrap..."

MICROMAMBA_ARCHIVE="$TMP_DIR/micromamba.tar.bz2"
if [[ "$DOWNLOAD_TOOL" == "curl" ]]; then
  run_and_log curl -L "$MICROMAMBA_TARBALL_URL" -o "$MICROMAMBA_ARCHIVE"
else
  run_and_log wget -O "$MICROMAMBA_ARCHIVE" "$MICROMAMBA_TARBALL_URL"
fi

run_and_log tar -xjf "$MICROMAMBA_ARCHIVE" -C "$TMP_DIR"

if [[ ! -f "$TMP_DIR/bin/micromamba" ]]; then
  echo "Micromamba archive did not contain bin/micromamba" >&2
  exit 1
fi

install -m 0755 "$TMP_DIR/bin/micromamba" "$BIN_DIR/micromamba"

log "Creating EasyRob environment..."
run_and_log "$BIN_DIR/micromamba" create -y -p "$ENV_PREFIX" -f "$ENV_FILE"

log "Installing launcher..."
install -m 0755 "$SCRIPT_DIR/launch_easyrob.sh" "$LAUNCHER_TARGET"

if [[ -f "$ICON_SOURCE" ]]; then
  log "Installing icon..."
  install -m 0644 "$ICON_SOURCE" "$ICON_TARGET"
fi

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=EasyRob
Comment=Launch EasyRob with its private environment
Exec=$LAUNCHER_TARGET
TryExec=$LAUNCHER_TARGET
Terminal=false
Path=$INSTALL_ROOT
Icon=$ICON_TARGET
Categories=Science;
EOF

chmod 0644 "$DESKTOP_FILE"

if command -v update-desktop-database >/dev/null 2>&1; then
  run_and_log update-desktop-database "$(dirname "$DESKTOP_FILE")"
fi

log "EasyRob installation completed."
log "Launcher: $LAUNCHER_TARGET"
log "Desktop entry: $DESKTOP_FILE"
log "Error log: $ERROR_LOG"
