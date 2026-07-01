#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DIST_DIR="$REPO_ROOT/dist/linux"
STAGE_DIR="$SCRIPT_DIR/.build/deb-root"
DEBIAN_DIR="$STAGE_DIR/DEBIAN"
PACKAGE_NAME="easyrob"
MICROMAMBA_ASSET="$SCRIPT_DIR/assets/micromamba-linux-64"
SHARED_VERSION_FILE="$REPO_ROOT/packaging/shared/version.txt"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command dpkg-deb
require_command install

if [[ ! -f "$SHARED_VERSION_FILE" ]]; then
  echo "Required shared version file is missing: $SHARED_VERSION_FILE" >&2
  exit 1
fi

VERSION="$(head -n 1 "$SHARED_VERSION_FILE" | tr -d '\r\n')"
if [[ -z "$VERSION" ]]; then
  echo "Could not determine the EasyRob version from $SHARED_VERSION_FILE" >&2
  exit 1
fi

rm -rf "$STAGE_DIR"
mkdir -p \
  "$DEBIAN_DIR" \
  "$STAGE_DIR/usr/bin" \
  "$STAGE_DIR/usr/lib/easyrob/bootstrap" \
  "$STAGE_DIR/usr/lib/easyrob/scripts" \
  "$STAGE_DIR/usr/lib/easyrob/shared" \
  "$STAGE_DIR/usr/share/applications" \
  "$STAGE_DIR/usr/share/pixmaps" \
  "$DIST_DIR"

if [[ ! -f "$MICROMAMBA_ASSET" ]]; then
  echo "Micromamba asset not found: $MICROMAMBA_ASSET" >&2
  exit 1
fi

cat > "$DEBIAN_DIR/control" <<EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: science
Priority: optional
Architecture: all
Maintainer: The Alegre Group
Depends: bash, tar, curl | wget
Recommends: desktop-file-utils
Description: EasyRob full Debian installer
 This package installs the EasyRob launcher, menu entry, and runtime bootstrap.
 The Conda-based environment is created on first launch in the user's profile.
EOF

install -m 0755 "$SCRIPT_DIR/scripts/easyrob_bootstrap.sh" "$STAGE_DIR/usr/bin/easyrob"
install -m 0755 "$MICROMAMBA_ASSET" "$STAGE_DIR/usr/lib/easyrob/bootstrap/micromamba"
install -m 0755 "$SCRIPT_DIR/scripts/install_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/install_easyrob.sh"
install -m 0755 "$SCRIPT_DIR/scripts/launch_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/launch_easyrob.sh"
install -m 0755 "$SCRIPT_DIR/scripts/uninstall_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/uninstall_easyrob.sh"
install -m 0755 "$SCRIPT_DIR/scripts/uninstall_easyrob_full.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/uninstall_easyrob_full.sh"
install -m 0644 "$REPO_ROOT/packaging/shared/env.yaml" "$STAGE_DIR/usr/lib/easyrob/shared/env.yaml"
printf '%s\n' "$VERSION" > "$STAGE_DIR/usr/lib/easyrob/shared/version.txt"
install -m 0644 "$REPO_ROOT/packaging/windows/assets/Robert_icon.ico" "$STAGE_DIR/usr/share/pixmaps/easyrob.ico"

cat > "$STAGE_DIR/usr/share/applications/easyrob.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=EasyRob
Comment=Launch EasyRob
Exec=/usr/bin/easyrob
TryExec=/usr/bin/easyrob
Terminal=false
Icon=/usr/share/pixmaps/easyrob.ico
Categories=Science;
Keywords=EasyRob;ROBERT;chemistry;science;
StartupNotify=true
StartupWMClass=EasyRob
NoDisplay=false
EOF

cat > "$DEBIAN_DIR/postinst" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications || true
fi
EOF

cat > "$DEBIAN_DIR/postrm" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "purge" ]]; then
  if [[ -d /opt/easyrob ]]; then
    rm -rf /opt/easyrob
  fi
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications || true
fi
EOF

chmod 0755 "$DEBIAN_DIR/postinst" "$DEBIAN_DIR/postrm"

OUTPUT_FILE="$DIST_DIR/${PACKAGE_NAME}-${VERSION}.deb"
dpkg-deb --build "$STAGE_DIR" "$OUTPUT_FILE"

echo "Debian package created:"
echo "  $OUTPUT_FILE"
