#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
MICROMAMBA_BIN="$INSTALL_ROOT/bin/micromamba"
ENV_PREFIX="$INSTALL_ROOT/envs/easyrob"
LOG_DIR="$INSTALL_ROOT/logs"
RUNTIME_LOG="$LOG_DIR/runtime.log"

mkdir -p "$LOG_DIR"

log() {
  printf '%s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "$*" >> "$RUNTIME_LOG"
}

if [[ ! -x "$MICROMAMBA_BIN" ]]; then
  echo "EasyRob is not installed. Missing Micromamba at $MICROMAMBA_BIN" >&2
  exit 1
fi

if [[ ! -d "$ENV_PREFIX" ]]; then
  echo "EasyRob environment not found at $ENV_PREFIX" >&2
  exit 1
fi

log "Launching EasyRob from $ENV_PREFIX"

exec "$MICROMAMBA_BIN" run -p "$ENV_PREFIX" python -c \
  "from robert.gui_easyrob.easyrob_launcher import main; raise SystemExit(main() or 0)"
