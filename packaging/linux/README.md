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

The first-launch runtime, environment, bundled Micromamba copy, and logs all live under that folder.

Remove the per-user runtime first:

```bash
easyrob --uninstall-user-data
```

Then remove the system package:

```bash
sudo apt remove easyrob
```

If the package was already removed first, delete the runtime manually:

```bash
rm -rf ~/.local/share/easyrob
```

For full details, see:

- [Linux packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-linux.md)
