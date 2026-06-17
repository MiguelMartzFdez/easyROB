#!/usr/bin/env bash
set -euo pipefail

export EASYROB_SYSTEM_ROOT="${EASYROB_SYSTEM_ROOT:-/opt/easyrob}"
export EASYROB_INSTALL_ROOT="$EASYROB_SYSTEM_ROOT"
export EASYROB_SCRIPT_ROOT="${EASYROB_SCRIPT_ROOT:-/usr/lib/easyrob}"

if [[ ! -d "$EASYROB_SYSTEM_ROOT/envs/easyrob" ]]; then
  echo "EasyRob runtime is not installed at $EASYROB_SYSTEM_ROOT" >&2
  exit 1
fi

exec "$EASYROB_SCRIPT_ROOT/scripts/launch_easyrob.sh"
