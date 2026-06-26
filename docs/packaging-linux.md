# EasyRob Linux Packaging

This document explains how to generate and maintain the Linux package.

## Output

```text
dist/linux/easyrob-<VERSION>.deb
```

## Target platform

The current Linux package targets Ubuntu and other Debian-based distributions.

## Build command

From the repository root on Linux:

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

## Build requirements

- Linux
- `dpkg-deb`
- `install`
- `grep`
- `sed`
- `packaging/linux/assets/micromamba-linux-64`

## Source of truth

Linux packaging is driven by:

```text
packaging/shared/env.yaml
```

If dependencies change, edit that file first.

## Relevant files

- `packaging/linux/build-deb.sh`
- `packaging/linux/assets/micromamba-linux-64`
- `packaging/linux/scripts/easyrob_bootstrap.sh`
- `packaging/linux/scripts/install_easyrob.sh`
- `packaging/linux/scripts/launch_easyrob.sh`
- `packaging/linux/scripts/uninstall_easyrob.sh`

## What the package does

1. Installs the EasyRob launcher under `/usr/bin/easyrob`
2. Installs the shared environment definition under `/usr/lib/easyrob/shared/env.yaml`
3. Installs the bundled Micromamba bootstrap under `/usr/lib/easyrob/bootstrap/micromamba`
4. Creates an applications menu entry under `/usr/share/applications`

The `.deb` does not create the Conda/Python runtime during package installation. The runtime is created on first launch in the current user's profile:

```text
~/.local/share/easyrob
```

## User installation

### Graphical install

1. Download `easyrob-<VERSION>.deb`
2. Double-click the package
3. Install it with the system package installer
4. Open **EasyRob** from the applications menu or desktop shortcut

The first launch creates the private runtime and may take a few minutes.

### Terminal install

```bash
sudo apt install ./easyrob-<VERSION>.deb
```

## Log location

Runtime installation and launch logs are written under:

```text
~/.local/share/easyrob/logs
~/.local/state/easyrob/logs
```

## User removal

Remove the package:

```bash
sudo dpkg -r easyrob
```

Remove the package:

```bash
sudo dpkg --purge easyrob
```

Remove the per-user runtime if you also want to remove downloaded packages, logs, and environments:

```bash
easyrob --uninstall-user-data
```

## When to update Linux packaging

### Package-only changes

Change Linux packaging files only when you are updating:

- `.deb` metadata
- shortcut behavior
- launcher behavior
- install and uninstall scripts
- startup message behavior

Then rebuild the package:

```bash
./packaging/linux/build-deb.sh
```

### Dependency changes

1. Edit `packaging/shared/env.yaml`
2. Rebuild the package
3. Test the package on Ubuntu or another Debian-based system

The current Linux package resolves from `packaging/shared/env.yaml`.
