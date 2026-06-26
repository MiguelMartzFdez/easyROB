# macOS Bootstrap Assets

This folder stores the required bootstrap assets for the macOS build.

Supported filenames:

- `micromamba-osx-64`
- `micromamba-osx-arm64`
- `easyrob.icns`

`packaging/macos/build.sh` requires both Micromamba binaries so the generated `.dmg` can bootstrap on Intel and Apple Silicon Macs without downloading anything on first launch.

`easyrob.icns` is also required. The build fails if any of these assets are missing.
