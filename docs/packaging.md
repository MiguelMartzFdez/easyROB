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

## What to change when EasyRob is updated

There are two different kinds of updates:

### 1. Installer-only updates

Examples:

- changing setup text
- changing popup messages
- changing desktop shortcut behavior
- changing launcher logic
- changing Debian package metadata

In these cases, do not touch the environment definition or locks unless dependencies also changed.

Files that typically change:

- `packaging/windows/installer/EasyRob.iss`
- `packaging/windows/installer/scripts/*`
- `packaging/linux/scripts/*`
- `packaging/linux/build-deb.sh`
- `docs/*`

### 2. Dependency or application-environment updates

Examples:

- new Python package version
- added Conda package
- removed dependency
- changed Python version

In these cases:

1. edit `packaging/shared/env.yaml`
2. regenerate the platform-specific lock files when needed
3. rebuild the installer/package for that platform

## Source of truth

The source of truth for dependencies is:

- `packaging/shared/env.yaml`

Windows does not resolve directly from that file during user installation. It installs from frozen lock files.

Linux currently does resolve from that file at install time or first launch bootstrap, unless Linux-specific lock files are introduced later.

## Quick reference

### Windows

- dependency source: `packaging/shared/env.yaml`
- files consumed by the installer: `packaging/windows/installer/locks/conda-explicit.txt` and `packaging/windows/installer/locks/requirements.txt`
- build command: `.\build_installer.ps1`

### Linux

- dependency source: `packaging/shared/env.yaml`
- current resolver: `micromamba` on the target Linux machine
- build command for bootstrap script flow: use `packaging/linux/scripts/install_easyrob.sh`
- build command for Debian package: `./packaging/linux/build-deb.sh`

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
