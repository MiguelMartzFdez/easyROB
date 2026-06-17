# EasyRob macOS Packaging

This folder contains the macOS packaging scaffold for EasyRob.

## Target output

```text
dist/macos/easyrob-<VERSION>.dmg
```

The application bundle inside it should be:

```text
EasyRob.app
```

## Build

Run on a real Mac:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

## Dependency source

macOS packaging should use:

```text
packaging/shared/env.yaml
```

## Current status

The scaffold is already in the repository, but the final `.dmg` still has to be completed on macOS by bundling the runtime into `EasyRob.app`.

For the full workflow, see:

- [macOS packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-macos.md)
