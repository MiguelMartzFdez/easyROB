# EasyRob macOS Packaging

This document describes the hardened macOS bootstrap-app packaging for EasyRob.

## Output

```text
dist/macos/easyrob-<VERSION>.dmg
```

## Packaging goals

- `EasyRob.app` is immutable after the user copies it into `Applications`
- no runtime state is stored inside the `.app` bundle
- no `sudo` is required
- no direct dependency on Desktop, Downloads, or Documents
- all persistent state lives under `~/Library/ApplicationSupport/EasyRob`

## Compatibility target

- macOS 11 Big Sur or newer
- Intel Macs through the `osx-64` Micromamba bootstrap asset
- Apple Silicon Macs through the `osx-arm64` Micromamba bootstrap asset

## Source of truth

Shared dependencies are still defined in:

```text
packaging/shared/env.yaml
packaging/shared/version.txt
```

## Relevant files

- `packaging/macos/build.sh`
- `packaging/macos/README.md`
- `packaging/macos/assets/`
- `packaging/macos/app/EasyRob.app/Contents/Info.plist`
- `packaging/macos/scripts/bootstrap_easyrob_macos.sh`
- `packaging/macos/scripts/launch_easyrob_macos.sh`

## Build command

Run on macOS:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

## Build requirements

- a real Mac
- macOS 11 Big Sur or newer
- `rsync`
- `hdiutil`
- `codesign`
- `sed`

## Required assets

The macOS build requires:

- `packaging/macos/assets/micromamba-osx-64`
- `packaging/macos/assets/micromamba-osx-arm64`
- `packaging/macos/assets/easyrob.icns`

The build now fails if any of those files are missing.

## What the build does

1. Reads the EasyRob version from `packaging/shared/version.txt`
2. Stages `EasyRob.app`
3. Copies `packaging/shared/env.yaml` into the app resources
4. Copies the macOS bootstrap and launcher scripts
5. Bundles both Micromamba bootstrap binaries inside the app resources
6. Clears extended attributes on the staged `.app`
7. Applies ad hoc signing with `codesign --deep --sign -`
8. Creates a `.dmg` containing `EasyRob.app` and an `Applications` shortcut

## User installation flow

1. Download `easyrob-<VERSION>.dmg`
2. Open the disk image
3. Drag `EasyRob.app` into `Applications`
4. Launch EasyRob from Applications, Launchpad, or Spotlight
5. On first launch, EasyRob creates its private runtime entirely inside the user profile and then exits
6. On the second launch, EasyRob opens the GUI
7. Later launches reuse that installed runtime

## Runtime layout

All macOS state lives under:

```text
~/Library/ApplicationSupport/EasyRob
```

Current layout:

```text
ApplicationSupport/
└── EasyRob/
    ├── workspace/
    ├── micromamba/
    ├── env/
    ├── cache/
    └── logs/
```

Notes:

- `workspace/` is the only supported place for CSV files and project folders in the current macOS workflow
- `micromamba/` stores the copied Micromamba binary and its root prefix
- `env/` stores the private EasyRob environment
- `cache/` stores generated metadata such as version markers and split dependency files
- `logs/` stores installation and runtime logs
- `uninstall_easyrob.command` and `uninstall_easyrob.sh` provide a simple user-level uninstall entry point

## First-launch behavior

On first launch, the bootstrapper:

1. Creates the full directory structure under `~/Library/ApplicationSupport/EasyRob`
2. Copies the correct bundled Micromamba binary from the app resources into `micromamba/bin/micromamba`
3. Runs `chmod +x` on the copied binary
4. Clears quarantine attributes on the copied binary and generated runtime directories
5. Sets `MAMBA_ROOT_PREFIX` explicitly inside the private runtime tree
6. Creates the environment with absolute paths
7. Installs pip packages from the shared environment definition
8. Writes detailed logs to `logs/install.log` and `logs/install-error.log`
9. Writes a reusable uninstall script into `~/Library/ApplicationSupport/EasyRob`
10. Shows an installation-complete message and exits
11. Launches EasyRob from the private environment with the workspace as the working directory on the next open

## Protected-folder policy

The current macOS packaging intentionally avoids depending on TCC-protected folders.

That means:

- EasyRob does not assume direct access to Desktop
- EasyRob does not assume direct access to Downloads
- EasyRob does not assume direct access to Documents
- users should manually move CSV files into `~/Library/ApplicationSupport/EasyRob/workspace`

## User removal

To remove EasyRob on macOS:

1. Delete `EasyRob.app` from `Applications`
2. Delete `~/Library/ApplicationSupport/EasyRob`

EasyRob also generates:

```text
~/Library/ApplicationSupport/EasyRob/uninstall_easyrob.command
~/Library/ApplicationSupport/EasyRob/uninstall_easyrob.sh
```

The `.command` file can be opened with double click. The shell version can be run with:

```bash
bash "$HOME/Library/ApplicationSupport/EasyRob/uninstall_easyrob.sh"
```

The uninstaller verifies whether both the private EasyRob directory and `EasyRob.app` were actually removed. If macOS blocks removal of the app bundle, it reports that explicitly and falls back to a manual delete of `/Applications/EasyRob.app`.
It also verifies the expected EasyRob paths before running any recursive delete, so it only removes the fixed EasyRob locations and aborts if those paths are unexpected.

## Testing focus

The main macOS checks are now:

1. Build on a real Mac
2. Test first launch on Big Sur 11.7 Intel
3. Test first launch on Apple Silicon
4. Verify the `.dmg` drag-to-Applications flow
5. Verify that reinstalling a new version recreates the private runtime cleanly
6. Verify that logs are written under `~/Library/ApplicationSupport/EasyRob/logs`
7. Verify that workflows run from the private workspace

## Signing

The build now applies ad hoc signing before the DMG is created:

```bash
codesign --force --deep --sign - EasyRob.app
```

This is not a replacement for Developer ID signing or notarization, but it reduces problems with bundled helper binaries during local distribution and testing.
