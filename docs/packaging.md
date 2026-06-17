# EasyRob Packaging Overview

This repository keeps packaging separated by operating system so the workspace stays easy to understand.

## Main rule

Dependencies are shared across platforms from one place:

```text
packaging/shared/env.yaml
```

If the runtime changes, edit that file first.

## Folder layout

```text
EasyRob/
|-- packaging/
|   |-- shared/
|   |   |-- env.yaml
|   |   `-- README.md
|   |-- windows/
|   |   |-- build.ps1
|   |   `-- installer/
|   |       |-- EasyRob.iss
|   |       |-- assets/
|   |       |-- locks/
|   |       |-- scripts/
|   |       `-- source/
|   |-- linux/
|   |   |-- assets/
|   |   |-- locks/
|   |   |-- scripts/
|   |   |-- source/
|   |   |-- README.md
|   |   `-- build-deb.sh
|   `-- macos/
|       |-- assets/
|       |-- app/
|       |-- scripts/
|       |-- README.md
|       `-- build.sh
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

## Platform outputs

- Windows: `dist/windows/easyrob-<VERSION>.exe`
- Linux: `dist/linux/easyrob-<VERSION>.deb`
- macOS: `dist/macos/EasyRob.app` and `dist/macos/easyrob-<VERSION>.zip`

## Platform model

### Windows

- installer format: `.exe`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `.\build_installer.ps1`
- end-user result: EasyRob appears in Start Menu, Windows Search, and optionally on the Desktop

### Linux

- installer format: `.deb`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `./packaging/linux/build-deb.sh`
- end-user result: EasyRob appears in the applications menu and can also create a desktop shortcut

### macOS

- current distribution formats: `.app` and `.zip`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `./packaging/macos/build.sh`
- current status: bootstrap-app flow implemented, build and testing must happen on a real Mac

## What to change

### If only installer behavior changed

Examples:

- setup text
- shortcut behavior
- launch messages
- package metadata
- icon or launcher adjustments

Then update only the relevant platform folder and docs.

### If dependencies changed

1. Edit `packaging/shared/env.yaml`
2. Rebuild the platform installer
3. Verify a clean installation on that platform

## Role of locks

The `locks/` folders are platform-specific snapshots and support files.

They are not the primary source of truth. The primary source of truth is still:

```text
packaging/shared/env.yaml
```
