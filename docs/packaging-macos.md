# EasyRob macOS Packaging

This document explains the current macOS bootstrap-app packaging for EasyRob.

## Current outputs

```text
dist/macos/EasyRob.app
dist/macos/easyrob-<VERSION>.zip
```

## Current status

The bootstrap app workflow is now defined in the repository, but it still has to be built and tested on a real Mac.

## Build command

On macOS:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

## Build requirements

- a real Mac
- `rsync`
- `ditto`
- `grep`
- `sed`

## Source of truth

macOS packaging should use the same dependency source as the other platforms:

```text
packaging/shared/env.yaml
```

## Relevant files

- `packaging/macos/build.sh`
- `packaging/macos/README.md`
- `packaging/macos/assets/`
- `packaging/macos/app/EasyRob.app/Contents/Info.plist`
- `packaging/macos/scripts/bootstrap_easyrob_macos.sh`
- `packaging/macos/scripts/launch_easyrob_macos.sh`

## What the current build does

1. Reads the version from the Windows installer definition
2. Creates a staged `EasyRob.app`
3. Copies `packaging/shared/env.yaml` into the app resources
4. Copies the bootstrap and launcher scripts
5. Optionally bundles predownloaded Micromamba binaries
6. Copies `EasyRob.app` into `dist/macos/`
7. Creates `dist/macos/easyrob-<VERSION>.zip`

## User installation model

The intended user flow is:

1. Download `easyrob-<VERSION>.zip`
2. Extract the downloaded archive
3. Move `EasyRob.app` to `Applications`
4. Open EasyRob from Applications, Launchpad, or Spotlight
5. On first launch, EasyRob installs Micromamba and creates the environment under `~/Library/Application Support/EasyRob`
6. Later launches reuse the installed runtime

## Runtime location

The macOS bootstrapper stores its runtime here:

```text
~/Library/Application Support/EasyRob
```

That location contains:

- `bin/micromamba`
- `envs/easyrob`
- `logs/`
- `state/`

## User removal

To remove EasyRob on macOS:

1. Delete `EasyRob.app` from `Applications`
2. Remove `~/Library/Application Support/EasyRob` if you also want to remove the installed runtime and logs

## What is still missing

To finish hardening macOS packaging:

1. Build on a real Mac
2. Test both Intel and Apple Silicon
3. Decide whether to keep `.zip` only or also add a `.dmg`
4. Test launch, Spotlight discovery, updates, and removal

## Signing

Code signing and notarization are intentionally out of scope for now.

That means Gatekeeper warnings are expected until signing is added later.
