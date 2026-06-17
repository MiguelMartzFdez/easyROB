#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESOURCES_DIR="$APP_ROOT/Resources"
RUNTIME_DIR="$RESOURCES_DIR/runtime"
MICROMAMBA_BIN="$RUNTIME_DIR/bin/micromamba"
ENV_PREFIX="$RUNTIME_DIR/envs/easyrob"
LOG_ROOT="${HOME}/.local/state/easyrob-macos/logs"
RUNTIME_LOG="$LOG_ROOT/runtime.log"
RUNTIME_ERR_LOG="$LOG_ROOT/runtime-error.log"

mkdir -p "$LOG_ROOT"

show_notice() {
  osascript -e 'display dialog "EasyRob is opening..." buttons {"OK"} default button "OK" giving up after 2 with icon note' >/dev/null 2>&1 || true
}

show_notice

if [[ ! -x "$MICROMAMBA_BIN" ]]; then
  printf '%s\n' "Missing micromamba runtime at: $MICROMAMBA_BIN" >>"$RUNTIME_ERR_LOG"
  exit 1
fi

exec "$MICROMAMBA_BIN" run -p "$ENV_PREFIX" \
  python -c "from robert.gui_easyrob.easyrob_launcher import main; raise SystemExit(main() or 0)" \
  >>"$RUNTIME_LOG" 2>>"$RUNTIME_ERR_LOG"
