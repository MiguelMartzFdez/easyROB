# EasyRob macOS Packaging

This folder contains the macOS bootstrap-app packaging for EasyRob.

## Current outputs

```text
dist/macos/easyrob-<VERSION>.dmg
```

The `.dmg` is the distribution artifact. `EasyRob.app` exists inside the mounted disk image for the user to drag into `Applications`.

## Build

Run on a real Mac:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

Requirements:

- macOS 11 Big Sur or newer
- `rsync`
- `hdiutil`
- `codesign`
- `grep`
- `sed`

## Dependency source

macOS packaging should use:

```text
packaging/shared/env.yaml
```

## Current status

The macOS package now follows the same lightweight model as Windows and Linux:

- `EasyRob.app` is a bootstrap launcher
- `EasyRob.app` remains immutable after it is copied to `Applications`
- first launch copies the bundled Micromamba binary and creates the environment
- first launch finishes installation and exits without opening the GUI automatically
- the runtime is stored under `~/Library/Application Support/EasyRob`
- the private `pythonw` runtime root is stored under `~/Library/ApplicationSupport/EasyRob`
- the macOS workflow uses the private workspace under `~/Library/Application Support/EasyRob/workspace`
- first launch also creates `uninstall_easyrob.command` and `uninstall_easyrob.sh` in `~/Library/Application Support/EasyRob`
- the uninstaller verifies whether the app bundle was removed and tells the user if `/Applications/EasyRob.app` must be deleted manually
- later launches reuse that installed runtime

Compatibility target:

- macOS 11 Big Sur or newer
- Intel Macs using `osx-64`
- Apple Silicon Macs using `osx-arm64`

Required assets:

- `assets/micromamba-osx-64`
- `assets/micromamba-osx-arm64`
- `assets/easyrob.icns`

For the full workflow, see:

- [macOS packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-macos.md)
