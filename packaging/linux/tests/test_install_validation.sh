#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
TEST_DIR="$(mktemp -d -p "$PWD")"
case "$TEST_DIR" in
  "$PWD"/*) ;;
  *) echo "Unexpected test directory: $TEST_DIR" >&2; exit 1 ;;
esac
trap 'rm -rf "$TEST_DIR"' EXIT

cat >"$TEST_DIR/micromamba" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" != "create" ]]; then
  exit 1
fi
while [[ $# -gt 0 ]]; do
  if [[ "$1" == "-p" ]]; then
    prefix="$2"
    break
  fi
  shift
done
mkdir -p "$prefix/bin"
cat >"$prefix/bin/python" <<'PYTHON'
#!/usr/bin/env bash
case "$*" in
  *'from robert.gui_easyrob.easyrob_launcher import main'*) exit 17 ;;
  *'import robert'*) exit 0 ;;
  *) exit 0 ;;
esac
PYTHON
chmod +x "$prefix/bin/python"
EOF
chmod +x "$TEST_DIR/micromamba"

export EASYROB_INSTALL_ROOT="$TEST_DIR/runtime"
export EASYROB_SHARED_ROOT="$REPO_ROOT/packaging/shared"
export EASYROB_ICON_SOURCE="$REPO_ROOT/packaging/windows/assets/Robert_icon.ico"
export EASYROB_BUNDLED_MICROMAMBA="$TEST_DIR/micromamba"
export EASYROB_SKIP_APPLICATION_DESKTOP=1
export EASYROB_SKIP_DESKTOP_SHORTCUT=1

if bash "$REPO_ROOT/packaging/linux/scripts/install_easyrob.sh" >"$TEST_DIR/stdout" 2>"$TEST_DIR/stderr"; then
  echo "Installation succeeded even though the GUI entry point could not be imported." >&2
  exit 1
fi

if [[ -f "$TEST_DIR/runtime/cache/installed-version.txt" ]]; then
  echo "A failed GUI validation marked the runtime as installed." >&2
  exit 1
fi

echo "Linux GUI validation test passed."
