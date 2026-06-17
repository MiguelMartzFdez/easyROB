# EasyRob Linux Packaging

This document defines the first Linux packaging target for EasyRob.

## Recommended first target

Use a lightweight shell installer first, then wrap that same bootstrap logic into a `.deb`.

That matches the current Windows behavior more closely:

- the distributed file stays small
- dependencies are downloaded at install time
- the private environment lives in a user-local directory
- the launcher runs the GUI from that private environment

## Current user-facing formats

- `install_easyrob.sh`: direct bootstrap installer for testing and manual installs
- `.deb`: system package that installs `/usr/bin/easyrob` and bootstraps the user-local environment on first launch

## How Linux works right now

Linux does not currently use frozen lock files for installation.

Instead:

1. the dependency source is `packaging/shared/env.yaml`
2. `micromamba` runs on the target Linux machine
3. the environment is created locally for that user

Current private environment location:

- `~/.local/share/easyrob/envs/easyrob`

Current bootstrap behavior:

- direct script install: `packaging/linux/scripts/install_easyrob.sh`
- Debian package install: `/usr/bin/easyrob` triggers bootstrap on first launch

So right now Linux resolves the environment from `env.yaml` on the Linux machine itself.
That is different from Windows.

## Initial Linux installation model

1. Download `packaging/linux/scripts/install_easyrob.sh`
2. The script downloads Micromamba into a private EasyRob directory
3. The script creates the `easyrob` environment from `packaging/shared/env.yaml`
4. The script writes a launcher command under the private install directory
5. The script creates a desktop entry in `~/.local/share/applications`
6. The script writes installation logs under the private EasyRob directory

Suggested install root:

`$HOME/.local/share/easyrob`

Suggested log directory:

`$HOME/.local/share/easyrob/logs`

## Why Micromamba

Micromamba is a better fit than bundling a large installer on Linux because:

- the bootstrap download is small
- it works well for user-local environments
- it avoids assuming a system Conda installation
- it stays close to the Conda-based workflow already used for Windows

## Current structure

```text
packaging/linux/
|-- locks/
|-- scripts/
|   |-- install_easyrob.sh
|   |-- launch_easyrob.sh
|   `-- uninstall_easyrob.sh
`-- source/
    `-- README.md
```

## Ubuntu-first behavior

The current Ubuntu-focused installer:

- downloads Micromamba dynamically
- creates a private environment under `~/.local/share/easyrob`
- installs a launcher at `~/.local/share/easyrob/bin/easyrob`
- creates `~/.local/share/applications/easyrob.desktop`
- creates `~/Desktop/EasyRob.desktop` when a desktop folder exists
- stores logs in `~/.local/share/easyrob/logs`
- reuses the current EasyRob icon asset from the packaging repository

The current `.deb` wrapper:

- installs a system launcher at `/usr/bin/easyrob`
- installs the shared environment file under `/usr/lib/easyrob/shared/env.yaml`
- installs a system menu entry under `/usr/share/applications/easyrob.desktop`
- bootstraps the private user environment on first launch

## Building the .deb

From the repository root on Ubuntu:

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

Expected output:

`dist/linux/easyrob_<VERSION>_all.deb`

## Installing the .deb

On Ubuntu:

```bash
sudo apt install ./dist/linux/easyrob_<VERSION>_all.deb
```

After installation:

- `EasyRob` appears in the applications menu
- the first launch runs the bootstrap and creates the private environment under `~/.local/share/easyrob`
- subsequent launches reuse that private environment

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
2. test the bootstrap again on Ubuntu
3. rebuild the `.deb` if you distribute the Debian package

At the moment there is no Linux lock refresh step because Linux is still resolving directly from `packaging/shared/env.yaml`.

## Linux update checklist

### Script installer

1. edit `packaging/shared/env.yaml` if dependencies changed
2. run `packaging/linux/scripts/install_easyrob.sh` on Ubuntu
3. verify the created environment and launcher

### Debian package

1. edit `packaging/shared/env.yaml` if dependencies changed
2. run `./packaging/linux/build-deb.sh`
3. install the resulting `.deb`
4. verify first launch bootstrap and second launch reuse

## Next technical steps

1. Test `install_easyrob.sh` on a real Linux machine
2. Confirm the GUI entry point works with the private environment
3. Freeze Linux-specific versions if Linux needs a platform-specific override beyond `packaging/shared/env.yaml`
4. Test the `.deb` install, first launch, desktop integration, and package removal on Ubuntu
