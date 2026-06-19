#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WINDOWS_ISS="$REPO_ROOT/packaging/windows/EasyRob.iss"
APP_TEMPLATE="$SCRIPT_DIR/app/EasyRob.app"
BUILD_ROOT="$SCRIPT_DIR/.build"
APP_BUILD_DIR="$BUILD_ROOT/EasyRob.app"
DIST_DIR="$REPO_ROOT/dist/macos"
ASSETS_DIR="$SCRIPT_DIR/assets"
ICON_SOURCE="$ASSETS_DIR/easyrob.icns"
APP_DIST_DIR="$DIST_DIR/EasyRob.app"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command grep
require_command sed
require_command rsync
require_command ditto

VERSION="$(grep '^#define MyAppVersion "' "$WINDOWS_ISS" | sed -E 's/^#define MyAppVersion "(.+)"$/\1/' | head -n 1)"
if [[ -z "$VERSION" ]]; then
  echo "Could not determine EasyRob version from $WINDOWS_ISS" >&2
  exit 1
fi

rm -rf "$APP_BUILD_DIR" "$APP_DIST_DIR"
mkdir -p "$BUILD_ROOT" "$DIST_DIR"
rsync -a "$APP_TEMPLATE/" "$APP_BUILD_DIR/"

mkdir -p \
  "$APP_BUILD_DIR/Contents/MacOS" \
  "$APP_BUILD_DIR/Contents/Resources/shared" \
  "$APP_BUILD_DIR/Contents/Resources/scripts" \
  "$APP_BUILD_DIR/Contents/Resources/bootstrap"

install -m 0755 "$SCRIPT_DIR/scripts/launch_easyrob_macos.sh" "$APP_BUILD_DIR/Contents/MacOS/EasyRob"
install -m 0755 "$SCRIPT_DIR/scripts/bootstrap_easyrob_macos.sh" "$APP_BUILD_DIR/Contents/Resources/scripts/bootstrap_easyrob_macos.sh"
install -m 0644 "$REPO_ROOT/packaging/shared/env.yaml" "$APP_BUILD_DIR/Contents/Resources/shared/env.yaml"
printf '%s\n' "$VERSION" > "$APP_BUILD_DIR/Contents/Resources/shared/version.txt"

if [[ -f "$ICON_SOURCE" ]]; then
  install -m 0644 "$ICON_SOURCE" "$APP_BUILD_DIR/Contents/Resources/easyrob.icns"
else
  echo "macOS icon not found at $ICON_SOURCE; EasyRob.app will use the default app icon."
fi

for asset_name in micromamba-osx-64 micromamba-osx-arm64; do
  if [[ -f "$ASSETS_DIR/$asset_name" ]]; then
    install -m 0755 "$ASSETS_DIR/$asset_name" "$APP_BUILD_DIR/Contents/Resources/bootstrap/$asset_name"
  fi
done

sed -i.bak "s/__EASYROB_VERSION__/$VERSION/g" "$APP_BUILD_DIR/Contents/Info.plist"
rm -f "$APP_BUILD_DIR/Contents/Info.plist.bak"

rsync -a "$APP_BUILD_DIR/" "$APP_DIST_DIR/"

ZIP_OUTPUT="$DIST_DIR/easyrob-$VERSION.zip"
rm -f "$ZIP_OUTPUT"
(
  cd "$DIST_DIR"
  ditto -c -k --sequesterRsrc --keepParent "EasyRob.app" "$(basename "$ZIP_OUTPUT")"
)

echo "macOS app bundle created:"
echo "  $APP_DIST_DIR"
echo
echo "macOS distributable created:"
echo "  $ZIP_OUTPUT"
echo
echo "First launch behavior:"
echo "  - copies or downloads Micromamba on demand"
echo "  - creates the private runtime under ~/Library/Application Support/EasyRob"
echo "  - launches EasyRob and reuses that runtime on future launches"
