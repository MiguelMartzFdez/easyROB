#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${EASYROB_INSTALL_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/easyrob}"
ENV_PREFIX="$INSTALL_ROOT/envs/easyrob"
SCRIPT_ROOT="${EASYROB_SCRIPT_ROOT:-/usr/lib/easyrob}"
SYSTEM_ENV_FILE="${EASYROB_ENV_FILE:-$SCRIPT_ROOT/shared/env.yaml}"
SYSTEM_ICON_SOURCE="${EASYROB_ICON_SOURCE:-/usr/share/pixmaps/easyrob.ico}"

if [[ ! -d "$ENV_PREFIX" ]]; then
  export EASYROB_SHARED_ROOT="$SCRIPT_ROOT/shared"
  export EASYROB_ENV_FILE="$SYSTEM_ENV_FILE"
  export EASYROB_ICON_SOURCE="$SYSTEM_ICON_SOURCE"
  "$SCRIPT_ROOT/scripts/install_easyrob.sh"
fi

exec "$SCRIPT_ROOT/scripts/launch_easyrob.sh"
