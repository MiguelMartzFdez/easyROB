# EasyRob Linux Packaging

This document defines the current Linux packaging target for EasyRob.

## Current user-facing format

The Linux package distributed to users is:

- `dist/linux/easyrob-<VERSION>.deb`

## How Linux works right now

Linux does not currently use frozen lock files for installation.

Instead:

1. the dependency source is `packaging/shared/env.yaml`
2. `micromamba` runs on the target Linux machine
3. the environment is created locally during package installation

Current Debian-package behavior:

- package install creates the runtime during `postinst`
- system runtime path: `/opt/easyrob`
- launcher path: `/usr/bin/easyrob`
- the package should leave EasyRob ready to open immediately after installation

Linux still resolves the environment from `env.yaml` on the Linux machine itself, but the `.deb` does that during package installation instead of on first launch.

## Why Micromamba

Micromamba is a good fit for Linux because:

- the bootstrap payload stays small
- it avoids assuming a system Conda installation
- it stays close to the Conda-based workflow already used for Windows
- it keeps the runtime private to EasyRob

## Current structure

```text
packaging/linux/
|-- assets/
|-- scripts/
|   |-- install_easyrob.sh
|   |-- launch_easyrob.sh
|   `-- uninstall_easyrob.sh
|-- build-deb.sh
`-- source/
    `-- README.md
```

## Ubuntu-first behavior

The current `.deb` package:

- installs a system launcher at `/usr/bin/easyrob`
- bundles a `micromamba` binary inside the package
- installs the shared environment file under `/usr/lib/easyrob/shared/env.yaml`
- installs a system menu entry under `/usr/share/applications/easyrob.desktop`
- creates the full runtime under `/opt/easyrob` during package installation
- attempts to create `EasyRob.desktop` in the installing user's desktop directory
- should make EasyRob launchable immediately after package installation

## Building the .deb

From the repository root on Ubuntu:

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

Expected output:

`dist/linux/easyrob-<VERSION>.deb`

## Installing the .deb

On Ubuntu:

```bash
sudo dpkg -i dist/linux/easyrob-<VERSION>.deb
```

After installation:

- `EasyRob` appears in the applications menu
- `EasyRob.desktop` should appear on the installing user's desktop when the desktop directory can be resolved
- the runtime is already installed under `/opt/easyrob`
- launching `EasyRob` should open the program immediately

## Uninstalling the .deb

```bash
sudo dpkg -r easyrob
```

If you want to remove the installed runtime under `/opt/easyrob` as well:

```bash
sudo dpkg --purge easyrob
```

## What to change when EasyRob is updated

### If only Linux packaging changed

Examples:

- desktop shortcut behavior
- `.deb` metadata
- launcher script behavior
- bootstrap logging

Then update only:

- `packaging/linux/scripts/*`
- `packaging/linux/build-deb.sh`
- `docs/packaging-linux.md`

You do not need to touch dependencies.

### If dependencies changed

1. edit `packaging/shared/env.yaml`
2. rebuild the `.deb`
3. test the package on Ubuntu

At the moment there is no Linux lock refresh step because Linux is still resolving directly from `packaging/shared/env.yaml`.

## Linux update checklist

### Debian package

1. edit `packaging/shared/env.yaml` if dependencies changed
2. run `./packaging/linux/build-deb.sh`
3. install the resulting `.deb`
4. verify package installation creates `/opt/easyrob`
5. verify `easyrob` exists in `/usr/bin/easyrob`
6. verify the menu entry appears
7. verify the desktop shortcut appears for the installing user
8. verify launching `EasyRob` opens immediately
