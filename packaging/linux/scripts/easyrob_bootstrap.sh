#!/usr/bin/env bash
set -euo pipefail

export EASYROB_SCRIPT_ROOT="${EASYROB_SCRIPT_ROOT:-/usr/lib/easyrob}"
export EASYROB_INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
export EASYROB_ENV_FILE="${EASYROB_ENV_FILE:-$EASYROB_SCRIPT_ROOT/shared/env.yaml}"
export EASYROB_VERSION_FILE="${EASYROB_VERSION_FILE:-$EASYROB_SCRIPT_ROOT/shared/version.txt}"
export EASYROB_ICON_SOURCE="${EASYROB_ICON_SOURCE:-/usr/share/pixmaps/easyrob.ico}"
export EASYROB_BUNDLED_MICROMAMBA="${EASYROB_BUNDLED_MICROMAMBA:-$EASYROB_SCRIPT_ROOT/bootstrap/micromamba}"
export EASYROB_SKIP_APPLICATION_DESKTOP="${EASYROB_SKIP_APPLICATION_DESKTOP:-1}"
export EASYROB_SKIP_DESKTOP_SHORTCUT="${EASYROB_SKIP_DESKTOP_SHORTCUT:-1}"
NOTICE_PID=""
CURRENT_VERSION_FILE="$EASYROB_VERSION_FILE"
INSTALLED_VERSION_FILE="$EASYROB_INSTALL_ROOT/cache/installed-version.txt"
MICROMAMBA_BIN="$EASYROB_INSTALL_ROOT/bin/micromamba"
ENV_PREFIX="$EASYROB_INSTALL_ROOT/envs/easyrob"
ENV_PYTHON="$ENV_PREFIX/bin/python"

start_notice() {
  local text="$1"

  if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    return
  fi

  if command -v zenity >/dev/null 2>&1; then
    (
      zenity --info \
        --title="EasyRob" \
        --text="$text" \
        --width=420
    ) >/dev/null 2>&1 &
    NOTICE_PID="$!"
    return
  fi

  if command -v xmessage >/dev/null 2>&1; then
    (
      xmessage -center "$text"
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

if [[ "${1:-}" == "--uninstall" ]]; then
  exec "$EASYROB_SCRIPT_ROOT/scripts/uninstall_easyrob_full.sh"
fi

current_version=""
if [[ -f "$CURRENT_VERSION_FILE" ]]; then
  current_version="$(tr -d '\r\n' < "$CURRENT_VERSION_FILE")"
fi

installed_version=""
if [[ -f "$INSTALLED_VERSION_FILE" ]]; then
  installed_version="$(tr -d '\r\n' < "$INSTALLED_VERSION_FILE")"
fi

has_existing_install=0
if [[ -d "$EASYROB_INSTALL_ROOT" || -x "$MICROMAMBA_BIN" || -d "$ENV_PREFIX" || -n "$installed_version" ]]; then
  has_existing_install=1
fi

need_install=0
install_reason="first_install"
if [[ ! -x "$MICROMAMBA_BIN" || ! -d "$ENV_PREFIX" || ! -x "$ENV_PYTHON" ]]; then
  need_install=1
  if [[ "$has_existing_install" == "1" ]]; then
    install_reason="repair"
  fi
fi
if [[ -n "$current_version" && -n "$installed_version" && "$current_version" != "$installed_version" ]]; then
  need_install=1
  install_reason="update"
fi

if [[ "$need_install" == "1" ]]; then
  install_notice="EasyRob is being set up for the first time. This may take a few minutes. Please keep this window open."
  install_success_message=""

  if [[ "$install_reason" == "update" ]]; then
    install_notice="EasyRob found an existing installation and needs to update its private runtime. Installed version: ${installed_version:-unknown}. New version: ${current_version:-unknown}. This may take a few minutes. Please keep this window open."
    install_success_message="EasyRob finished updating its private runtime successfully. Please open EasyRob again to start the application."
  elif [[ "$install_reason" == "repair" ]]; then
    install_notice="EasyRob found an existing installation, but its private runtime is incomplete or damaged. EasyRob will repair the private runtime now. This may take a few minutes. Please keep this window open."
    install_success_message="EasyRob finished repairing its private runtime successfully. Please open EasyRob again to start the application."
  else
    install_success_message="EasyRob finished installing successfully. Please open EasyRob again to start the application."
  fi

  start_notice "$install_notice"
  trap stop_installing_notice EXIT
  "$EASYROB_SCRIPT_ROOT/scripts/install_easyrob.sh"
  stop_installing_notice
  trap - EXIT
  if [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
    if command -v zenity >/dev/null 2>&1; then
      zenity --info --title="EasyRob" --text="$install_success_message" --width=420 >/dev/null 2>&1 || true
    elif command -v xmessage >/dev/null 2>&1; then
      xmessage -center "$install_success_message" >/dev/null 2>&1 || true
    fi
  fi
  exit 0
fi

exec "$EASYROB_SCRIPT_ROOT/scripts/launch_easyrob.sh"
