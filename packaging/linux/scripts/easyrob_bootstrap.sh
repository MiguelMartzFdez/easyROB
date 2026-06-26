#!/usr/bin/env bash
set -euo pipefail

export EASYROB_SCRIPT_ROOT="${EASYROB_SCRIPT_ROOT:-/usr/lib/easyrob}"
export EASYROB_INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
export EASYROB_ENV_FILE="${EASYROB_ENV_FILE:-$EASYROB_SCRIPT_ROOT/shared/env.yaml}"
export EASYROB_ICON_SOURCE="${EASYROB_ICON_SOURCE:-/usr/share/pixmaps/easyrob.ico}"
export EASYROB_BUNDLED_MICROMAMBA="${EASYROB_BUNDLED_MICROMAMBA:-$EASYROB_SCRIPT_ROOT/bootstrap/micromamba}"

if [[ ! -d "$EASYROB_INSTALL_ROOT/envs/easyrob" ]]; then
  "$EASYROB_SCRIPT_ROOT/scripts/install_easyrob.sh"
fi

exec "$EASYROB_SCRIPT_ROOT/scripts/launch_easyrob.sh"
