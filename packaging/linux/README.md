# EasyRob Linux Packaging

This folder contains the Linux-specific packaging files for EasyRob.

## Output

```text
dist/linux/easyrob-<VERSION>.deb
```

## Build

Run on Ubuntu or another Debian-based Linux system:

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

## Dependency source

Linux packaging uses:

```text
packaging/shared/env.yaml
```

## Main contents

- `build-deb.sh`: builds the `.deb`
- `assets/`: bundled Linux packaging assets
- `scripts/`: first-launch install, launch, shortcut, and uninstall logic

The `.deb` installs launchers and static assets system-wide. The private runtime is created on first launch under the current user's profile:

```text
~/.local/share/easyrob
```

Remove the system package with `sudo apt remove easyrob`. Remove the per-user runtime with:

```bash
easyrob --uninstall-user-data
```

For full details, see:

- [Linux packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-linux.md)
