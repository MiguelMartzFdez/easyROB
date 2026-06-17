# EasyRob Packaging Overview

This repository packages EasyRob separately for each operating system.

## Goal

Keep the workspace easy to understand and avoid mixing Windows-only, Linux-only, and macOS-only installer logic in the same folder.

## Layout

```text
Easyrob/
|-- packaging/
|   |-- shared/
|   |   |-- env.yaml
|   |   `-- README.md
|   |-- windows/
|   |   |-- build.ps1
|   |   `-- installer/
|   |       |-- EasyRob.iss
|   |       |-- assets/
|   |       |-- scripts/
|   |       `-- source/
|   |-- linux/
|   |   |-- assets/
|   |   |-- scripts/
|   |   |-- source/
|   |   `-- build-deb.sh
|   `-- macos/
|       |-- app/
|       |-- scripts/
|       |-- build.sh
|       `-- README.md
|-- docs/
|   |-- packaging.md
|   |-- packaging-windows.md
|   |-- packaging-linux.md
|   `-- packaging-macos.md
`-- dist/
    |-- windows/
    |-- linux/
    `-- macos/
```

## Shared vs platform-specific files

- `packaging/shared/env.yaml`: edit this when the application environment changes for all operating systems.
- `packaging/windows/`: Windows-specific installer logic.
- `packaging/linux/`: Linux-specific package and launcher logic.
- `packaging/macos/`: macOS-specific app and disk-image scaffolding.

## Common rule

1. Edit `packaging/shared/env.yaml` when dependencies change.
2. Rebuild only the installer or package for the operating system you are updating.
3. Verify installation and launch behavior on that operating system.

## What to change when EasyRob is updated

There are two different kinds of updates.

### 1. Installer-only updates

Examples:

- changing setup text
- changing popup messages
- changing desktop shortcut behavior
- changing launcher logic
- changing package metadata

In these cases, do not touch `packaging/shared/env.yaml` unless dependencies also changed.

Files that typically change:

- `packaging/windows/installer/EasyRob.iss`
- `packaging/windows/installer/scripts/*`
- `packaging/linux/scripts/*`
- `packaging/linux/build-deb.sh`
- `packaging/macos/scripts/*`
- `packaging/macos/build.sh`
- `docs/*`

### 2. Dependency or runtime updates

Examples:

- new Python package version
- added Conda package
- removed dependency
- changed Python version

In these cases:

1. edit `packaging/shared/env.yaml`
2. rebuild the installer or package for the target platform
3. verify the generated runtime on that platform

## Source of truth

The source of truth for dependencies is:

- `packaging/shared/env.yaml`

Windows currently creates the runtime from that file during installation.

Linux currently creates the runtime from that file during package installation.

macOS should follow the same model when the final installer is completed.

## Quick reference

### Windows

- dependency source: `packaging/shared/env.yaml`
- build command: `.\build_installer.ps1`
- output: `dist/windows/easyrob-<VERSION>.exe`

### Linux

- dependency source: `packaging/shared/env.yaml`
- current resolver: bundled `micromamba` during package installation
- build command: `./packaging/linux/build-deb.sh`
- output: `dist/linux/easyrob-<VERSION>.deb`

### macOS

- dependency source: `packaging/shared/env.yaml`
- current status: scaffold prepared, final build must run on a real Mac
- build command: `./packaging/macos/build.sh`
- output target: `dist/macos/easyrob-<VERSION>.dmg`

## Platform model

- `Windows`: standard `.exe` installer that builds the private runtime during installation.
- `Linux`: `.deb` package that installs the private runtime during package installation.
- `macOS`: `.app` plus `.dmg` scaffold that will bundle the private runtime inside the app.
