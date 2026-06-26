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
|   |   |-- EasyRob.iss
|   |   |-- assets/
|   |   `-- scripts/
|   |-- linux/
|   |   |-- assets/
|   |   |-- scripts/
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
- macOS: `dist/macos/easyrob-<VERSION>.dmg`

## Build hosts

Each final artifact is built on its own operating system:

- Windows `.exe`: build on Windows
- Linux `.deb`: build on Linux
- macOS `.dmg`: build on macOS

The repository, dependency source, and packaging structure are shared, but the final installers are not all produced from one host.

## Platform model

### Windows

- installer format: `.exe`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `.\packaging\windows\build.ps1`
- build host: Windows with Inno Setup 6 or 7
- end-user result: EasyRob appears in Start Menu, Windows Search, and optionally on the Desktop

### Linux

- installer format: `.deb`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `./packaging/linux/build-deb.sh`
- build host: Linux with `dpkg-deb`
- end-user result: EasyRob appears in the applications menu and creates its private runtime on first launch

### macOS

- current distribution format: `.dmg`
- runtime source: `packaging/shared/env.yaml`
- build entry point: `./packaging/macos/build.sh`
- build host: a real Mac with `rsync`, `hdiutil`, and `codesign`
- app model: immutable bootstrap app
- runtime location: `~/Library/Application Support/EasyRob`
- workspace model: `~/Library/Application Support/EasyRob/workspace`
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
