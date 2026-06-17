# EasyRob macOS Packaging

This document defines the initial macOS packaging target for EasyRob.

## Goal

Match the same user-facing model already used on Windows and Linux:

- double-click installer media
- install EasyRob
- open EasyRob from Finder, Launchpad, Spotlight, or Applications
- keep the application runtime private to EasyRob

## Target artifact

The macOS distributable should be:

- `dist/macos/easyrob-<VERSION>.dmg`

The application bundle inside it should be:

- `EasyRob.app`

## Current scaffold

The repository now includes a first macOS packaging scaffold under:

```text
packaging/macos/
|-- app/
|   `-- EasyRob.app/
|       `-- Contents/
|           `-- Info.plist
|-- scripts/
|   `-- launch_easyrob_macos.sh
|-- build.sh
`-- README.md
```

## Build model

macOS should follow the same dependency source as the other platforms:

- `packaging/shared/env.yaml`

The intended final model is:

1. prepare the EasyRob runtime from `packaging/shared/env.yaml`
2. bundle the runtime inside `EasyRob.app`
3. wrap `EasyRob.app` into `easyrob-<VERSION>.dmg`

## What build.sh does

`packaging/macos/build.sh` currently:

1. reads the EasyRob version from `packaging/windows/installer/EasyRob.iss`
2. creates a staged `EasyRob.app`
3. copies `packaging/shared/env.yaml` into the app resources
4. installs the macOS launcher script
5. prepares the app for the final runtime bundling step

## Expected user experience

Once the macOS package is completed, the target behavior should be:

- the user opens `easyrob-<VERSION>.dmg`
- the user installs or drags `EasyRob.app`
- EasyRob is searchable from Spotlight
- EasyRob can be launched with a double-click
- EasyRob shows an opening message when startup takes a moment
- EasyRob can be deleted like a normal macOS app

## Signing and notarization

At this stage, code signing and notarization are intentionally out of scope.

That means:

- the `.app` and `.dmg` can still be built
- Gatekeeper warnings are expected on unsigned distributions
- signing can be added later without changing the workspace layout

## Next steps

1. run `packaging/macos/build.sh` on a real Mac
2. bundle micromamba and the prepared runtime into `EasyRob.app`
3. create `easyrob-<VERSION>.dmg`
4. verify launch, Spotlight discovery, and app removal on macOS
