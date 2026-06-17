# EasyRob macOS Packaging

This document explains the current macOS packaging scaffold and the next step required to turn it into a real installer.

## Target output

```text
dist/macos/easyrob-<VERSION>.dmg
```

The application inside that disk image should be:

```text
EasyRob.app
```

## Current status

The repository already contains the macOS scaffold, but the final `.dmg` is not produced yet.

The packaging work must be completed on a real Mac.

## Build command

On macOS:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

## Source of truth

macOS packaging should use the same dependency source as the other platforms:

```text
packaging/shared/env.yaml
```

## Relevant files

- `packaging/macos/build.sh`
- `packaging/macos/README.md`
- `packaging/macos/app/EasyRob.app/Contents/Info.plist`
- `packaging/macos/scripts/launch_easyrob_macos.sh`

## What the current scaffold does

1. Reads the version from the Windows installer definition
2. Creates a staged `EasyRob.app`
3. Copies `packaging/shared/env.yaml` into the app resources
4. Installs the macOS launcher script
5. Prepares the app structure for the final runtime bundle

## Planned user installation

Once the `.dmg` is finished, the intended user flow is:

1. Download `easyrob-<VERSION>.dmg`
2. Open the disk image
3. Install or drag `EasyRob.app`
4. Open EasyRob from Applications, Launchpad, or Spotlight

## What is still missing

To finish macOS packaging:

1. Build on a real Mac
2. Bundle micromamba and the prepared EasyRob runtime inside `EasyRob.app`
3. Create the final `easyrob-<VERSION>.dmg`
4. Test launch, Spotlight discovery, and removal

## Signing

Code signing and notarization are intentionally out of scope for now.

That means Gatekeeper warnings are expected until signing is added later.
