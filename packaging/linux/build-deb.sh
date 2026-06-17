#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WINDOWS_ISS="$REPO_ROOT/packaging/windows/installer/EasyRob.iss"
DIST_DIR="$REPO_ROOT/dist/linux"
STAGE_DIR="$SCRIPT_DIR/.build/deb-root"
DEBIAN_DIR="$STAGE_DIR/DEBIAN"
PACKAGE_NAME="easyrob"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command dpkg-deb
require_command install
require_command grep
require_command sed

VERSION="$(grep '^#define MyAppVersion "' "$WINDOWS_ISS" | sed -E 's/^#define MyAppVersion "(.+)"$/\1/' | head -n 1)"
if [[ -z "$VERSION" ]]; then
  echo "Could not determine EasyRob version from $WINDOWS_ISS" >&2
  exit 1
fi

rm -rf "$STAGE_DIR"
mkdir -p \
  "$DEBIAN_DIR" \
  "$STAGE_DIR/usr/bin" \
  "$STAGE_DIR/usr/lib/easyrob/scripts" \
  "$STAGE_DIR/usr/lib/easyrob/shared" \
  "$STAGE_DIR/usr/share/applications" \
  "$STAGE_DIR/usr/share/pixmaps" \
  "$DIST_DIR"

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
 This package installs the EasyRob launcher, menu entry, and full runtime.
 The Conda-based environment is created during package installation.
EOF

install -m 0755 "$SCRIPT_DIR/scripts/easyrob_bootstrap.sh" "$STAGE_DIR/usr/bin/easyrob"
install -m 0755 "$SCRIPT_DIR/scripts/install_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/install_easyrob.sh"
install -m 0755 "$SCRIPT_DIR/scripts/install_easyrob_system.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/install_easyrob_system.sh"
install -m 0755 "$SCRIPT_DIR/scripts/install_desktop_shortcut_system.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/install_desktop_shortcut_system.sh"
install -m 0755 "$SCRIPT_DIR/scripts/launch_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/launch_easyrob.sh"
install -m 0755 "$SCRIPT_DIR/scripts/uninstall_easyrob.sh" "$STAGE_DIR/usr/lib/easyrob/scripts/uninstall_easyrob.sh"
install -m 0644 "$REPO_ROOT/packaging/shared/env.yaml" "$STAGE_DIR/usr/lib/easyrob/shared/env.yaml"
install -m 0644 "$REPO_ROOT/packaging/windows/installer/assets/Robert_icon.ico" "$STAGE_DIR/usr/share/pixmaps/easyrob.ico"

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
EOF

cat > "$DEBIAN_DIR/postinst" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

export EASYROB_SCRIPT_ROOT=/usr/lib/easyrob
export EASYROB_SYSTEM_ROOT=/opt/easyrob
export EASYROB_INSTALL_ROOT=/opt/easyrob
export EASYROB_ENV_FILE=/usr/lib/easyrob/shared/env.yaml
export EASYROB_ICON_SOURCE=/usr/share/pixmaps/easyrob.ico

/usr/lib/easyrob/scripts/install_easyrob_system.sh

TARGET_USER="${SUDO_USER:-}"
if [[ -z "$TARGET_USER" ]] && command -v logname >/dev/null 2>&1; then
  TARGET_USER="$(logname 2>/dev/null || true)"
fi
if [[ -z "$TARGET_USER" ]] && getent passwd 1000 >/dev/null 2>&1; then
  TARGET_USER="$(getent passwd 1000 | cut -d: -f1)"
fi
if [[ -n "$TARGET_USER" ]] && id "$TARGET_USER" >/dev/null 2>&1; then
  /usr/lib/easyrob/scripts/install_desktop_shortcut_system.sh "$TARGET_USER" || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications || true
fi
EOF

cat > "$DEBIAN_DIR/postrm" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "purge" ]]; then
  rm -rf /opt/easyrob
fi

TARGET_USER="${SUDO_USER:-}"
if [[ -z "$TARGET_USER" ]] && command -v logname >/dev/null 2>&1; then
  TARGET_USER="$(logname 2>/dev/null || true)"
fi
if [[ -z "$TARGET_USER" ]] && getent passwd 1000 >/dev/null 2>&1; then
  TARGET_USER="$(getent passwd 1000 | cut -d: -f1)"
fi
if [[ -n "$TARGET_USER" ]] && id "$TARGET_USER" >/dev/null 2>&1; then
  USER_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
  if [[ -n "$USER_HOME" ]]; then
    DESKTOP_DIR="$USER_HOME/Desktop"
    if command -v runuser >/dev/null 2>&1 && command -v xdg-user-dir >/dev/null 2>&1; then
      DESKTOP_DIR="$(runuser -u "$TARGET_USER" -- xdg-user-dir DESKTOP 2>/dev/null || printf '%s\n' "$DESKTOP_DIR")"
    fi
    rm -f "$DESKTOP_DIR/EasyRob.desktop"
  fi
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications || true
fi
EOF

chmod 0755 "$DEBIAN_DIR/postinst" "$DEBIAN_DIR/postrm"

OUTPUT_FILE="$DIST_DIR/${PACKAGE_NAME}_${VERSION}_all.deb"
dpkg-deb --build "$STAGE_DIR" "$OUTPUT_FILE"

echo "Debian package created:"
echo "  $OUTPUT_FILE"
