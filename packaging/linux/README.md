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
- `scripts/`: install, launch, shortcut, and uninstall logic
- `source/`: Linux packaging notes

For full details, see:

- [Linux packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-linux.md)
