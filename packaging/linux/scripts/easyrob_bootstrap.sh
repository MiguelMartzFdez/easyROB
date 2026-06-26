#!/usr/bin/env bash
set -euo pipefail

export EASYROB_SCRIPT_ROOT="${EASYROB_SCRIPT_ROOT:-/usr/lib/easyrob}"
export EASYROB_INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
export EASYROB_ENV_FILE="${EASYROB_ENV_FILE:-$EASYROB_SCRIPT_ROOT/shared/env.yaml}"
export EASYROB_ICON_SOURCE="${EASYROB_ICON_SOURCE:-/usr/share/pixmaps/easyrob.ico}"
export EASYROB_BUNDLED_MICROMAMBA="${EASYROB_BUNDLED_MICROMAMBA:-$EASYROB_SCRIPT_ROOT/bootstrap/micromamba}"
NOTICE_PID=""

start_installing_notice() {
  if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    return
  fi

  if command -v zenity >/dev/null 2>&1; then
    (
      zenity --info \
        --title="EasyRob" \
        --text="EasyRob is being set up for the first time. This may take a few minutes. Please keep this window open." \
        --width=420
    ) >/dev/null 2>&1 &
    NOTICE_PID="$!"
    return
  fi

  if command -v xmessage >/dev/null 2>&1; then
    (
      xmessage -center "EasyRob is being set up for the first time. This may take a few minutes."
    ) >/dev/null 2>&1 &
    NOTICE_PID="$!"
  fi
}

stop_installing_notice() {
  if [[ -n "$NOTICE_PID" ]] && kill -0 "$NOTICE_PID" >/dev/null 2>&1; then
    kill "$NOTICE_PID" >/dev/null 2>&1 || true
    wait "$NOTICE_PID" 2>/dev/null || true
  fi
}

if [[ "${1:-}" == "--uninstall-user-data" ]]; then
  exec "$EASYROB_SCRIPT_ROOT/scripts/uninstall_easyrob.sh"
fi

if [[ ! -d "$EASYROB_INSTALL_ROOT/envs/easyrob" ]]; then
  start_installing_notice
  trap stop_installing_notice EXIT
  "$EASYROB_SCRIPT_ROOT/scripts/install_easyrob.sh"
  stop_installing_notice
  trap - EXIT
fi

exec "$EASYROB_SCRIPT_ROOT/scripts/launch_easyrob.sh"
