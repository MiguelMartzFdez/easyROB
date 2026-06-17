#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${EASYROB_SYSTEM_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}}"
MICROMAMBA_BIN="$INSTALL_ROOT/bin/micromamba"
ENV_PREFIX="$INSTALL_ROOT/envs/easyrob"
USER_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/easyrob"
LOG_DIR="$USER_STATE_DIR/logs"
RUNTIME_LOG="$LOG_DIR/runtime.log"
NOTICE_PID=""

mkdir -p "$LOG_DIR"

log() {
  printf '%s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "$*" >> "$RUNTIME_LOG"
}

start_opening_notice() {
  if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    return
  fi

  if command -v zenity >/dev/null 2>&1; then
    (
      zenity --info \
        --title="EasyRob" \
        --text="EasyRob is opening..." \
        --width=320 \
        --no-wrap
    ) >/dev/null 2>&1 &
    NOTICE_PID="$!"
    return
  fi

  if command -v xmessage >/dev/null 2>&1; then
    (
      xmessage -center "EasyRob is opening..."
    ) >/dev/null 2>&1 &
    NOTICE_PID="$!"
  fi
}

stop_opening_notice() {
  if [[ -n "$NOTICE_PID" ]] && kill -0 "$NOTICE_PID" >/dev/null 2>&1; then
    kill "$NOTICE_PID" >/dev/null 2>&1 || true
    wait "$NOTICE_PID" 2>/dev/null || true
  fi
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
log "Using micromamba at $MICROMAMBA_BIN"

start_opening_notice
trap stop_opening_notice EXIT

LAUNCH_COMMAND=(
  "$MICROMAMBA_BIN"
  run
  -p
  "$ENV_PREFIX"
  python
  -c
  "from robert.gui_easyrob.easyrob_launcher import main; raise SystemExit(main() or 0)"
)

"${LAUNCH_COMMAND[@]}"
