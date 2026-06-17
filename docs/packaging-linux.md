# EasyRob Linux Packaging

This document defines the first Linux packaging target for EasyRob.

## Recommended first target

Use a lightweight shell installer, not a bundled `AppImage`.

That matches the current Windows behavior more closely:

- the distributed file stays small
- dependencies are downloaded at install time
- the private environment lives in a user-local directory
- the launcher runs the GUI from that private environment

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
- stores logs in `~/.local/share/easyrob/logs`
- reuses the current EasyRob icon asset from the packaging repository

## Next technical steps

1. Test `install_easyrob.sh` on a real Linux machine
2. Confirm the GUI entry point works with the private environment
3. Freeze Linux-specific versions if Linux needs a platform-specific override beyond `packaging/shared/env.yaml`
4. Decide whether the user-facing artifact should remain a shell installer or later become a `.deb`
