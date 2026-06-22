# EasyRob macOS Packaging

This folder contains the macOS bootstrap-app packaging for EasyRob.

## Current outputs

```text
dist/macos/EasyRob.app
dist/macos/easyrob-<VERSION>.dmg
```

The `.dmg` is the distribution artifact and `EasyRob.app` is the actual application bundle.

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
- first launch installs Micromamba and creates the environment
- the runtime is stored under `~/Library/ApplicationSupport/EasyRob`
- later launches reuse that installed runtime

Compatibility target:

- macOS 11 Big Sur or newer
- Intel Macs using `osx-64`
- Apple Silicon Macs using `osx-arm64`

Optional assets:

- `assets/micromamba-osx-64`
- `assets/micromamba-osx-arm64`
- `assets/easyrob.icns`

For the full workflow, see:

- [macOS packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-macos.md)
