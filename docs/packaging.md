# EasyRob Packaging Overview

This repository packages EasyRob separately for each operating system.

## Goal

Keep the workspace easy to understand and avoid mixing Windows-only and Linux-only installer logic in the same folder.

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
|   |       |-- locks/
|   |       |-- scripts/
|   |       `-- source/
|   `-- linux/
|       |-- locks/
|       |-- scripts/
|       `-- source/
|-- docs/
|   |-- packaging.md
|   |-- packaging-windows.md
|   `-- packaging-linux.md
`-- dist/
    `-- windows/
```

## Shared vs platform-specific files

- `packaging/shared/env.yaml`: edit this when the application environment changes for all operating systems.
- `packaging/windows/installer/locks/`: Windows-only resolved lock files.
- `packaging/linux/locks/`: Linux-only resolved lock files.

The common rule is:

1. Edit `packaging/shared/env.yaml`
2. Regenerate the lock files for each operating system
3. Rebuild the installer for that operating system

## Platform model

- `Windows`: a standard installer that includes the bootstrap assets needed to install a private runtime.
- `Linux`: a lightweight installer script is the best first step when the goal is to keep the download small and let the target machine resolve and download packages during installation.

## Why Linux starts with a script

For EasyRob, the closest Linux equivalent to the current Windows model is not an `AppImage`.

An `AppImage` is more like a self-contained bundle. That is useful for portability, but it goes against the current requirement that the installer should stay small and download the environment during setup.

The simplest Linux-first model is:

1. Download a small `install_easyrob.sh`
2. Download Micromamba during install
3. Create a private environment under the user home directory
4. Write a launcher script
5. Optionally create a `.desktop` entry

Later, that same installer logic can be wrapped into:

- a `.deb`
- an `.rpm`
- a `makeself` archive

without rewriting the environment bootstrap logic.
