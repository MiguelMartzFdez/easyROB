#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WINDOWS_ISS="$REPO_ROOT/packaging/windows/installer/EasyRob.iss"
APP_TEMPLATE="$SCRIPT_DIR/app/EasyRob.app"
BUILD_ROOT="$SCRIPT_DIR/.build"
APP_BUILD_DIR="$BUILD_ROOT/EasyRob.app"
DIST_DIR="$REPO_ROOT/dist/macos"
ICON_SOURCE="$REPO_ROOT/packaging/windows/installer/assets/Robert_icon.ico"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command grep
require_command sed
require_command rsync

VERSION="$(grep '^#define MyAppVersion "' "$WINDOWS_ISS" | sed -E 's/^#define MyAppVersion "(.+)"$/\1/' | head -n 1)"
if [[ -z "$VERSION" ]]; then
  echo "Could not determine EasyRob version from $WINDOWS_ISS" >&2
  exit 1
fi

rm -rf "$APP_BUILD_DIR"
mkdir -p "$BUILD_ROOT" "$DIST_DIR"
rsync -a "$APP_TEMPLATE/" "$APP_BUILD_DIR/"

mkdir -p \
  "$APP_BUILD_DIR/Contents/MacOS" \
  "$APP_BUILD_DIR/Contents/Resources/shared" \
  "$APP_BUILD_DIR/Contents/Resources/runtime"

install -m 0755 "$SCRIPT_DIR/scripts/launch_easyrob_macos.sh" "$APP_BUILD_DIR/Contents/MacOS/EasyRob"
install -m 0644 "$REPO_ROOT/packaging/shared/env.yaml" "$APP_BUILD_DIR/Contents/Resources/shared/env.yaml"

if [[ -f "$ICON_SOURCE" ]]; then
  install -m 0644 "$ICON_SOURCE" "$APP_BUILD_DIR/Contents/Resources/easyrob.icns"
fi

sed -i.bak "s/__EASYROB_VERSION__/$VERSION/g" "$APP_BUILD_DIR/Contents/Info.plist"
rm -f "$APP_BUILD_DIR/Contents/Info.plist.bak"

echo "macOS app scaffold created:"
echo "  $APP_BUILD_DIR"
echo
echo "Next step on macOS:"
echo "  1. Bundle micromamba and the private runtime into Contents/Resources/runtime"
echo "  2. Build dist/macos/easyrob-$VERSION.dmg from EasyRob.app"
