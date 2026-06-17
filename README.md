# EasyRob

*EasyRob* is distributed with guided installers for **Windows** and **Linux**.

The goal is simple: the user should **download, install, and open EasyRob** without manually creating Conda environments or installing Python.

---

## Overview

| Platform | Format | What happens during install |
| --- | --- | --- |
| **Windows** | `easyrob-<VERSION>.exe` | The installer sets up a private Miniforge-based runtime and creates the EasyRob shortcuts. |
| **Linux (Ubuntu)** | `easyrob-<VERSION>.deb` or `install_easyrob.sh` | The `.deb` installs the full runtime and launcher. The `.sh` installer creates a private user-local environment with *Micromamba*. |

---

## Windows

### User installation

1. Download `easyrob-<VERSION>.exe`.
2. Double-click the installer.
3. Follow the setup steps shown on screen.
4. Open **EasyRob** from the Start Menu, Windows Search, or the Desktop shortcut if you enabled it.

### Notes

- The installer creates a **private runtime** just for EasyRob.
- No separate Python or Conda installation is required.
- The first installation can take a few minutes.
- The first launch can also be a bit slower while Windows finishes preparing the environment.
- During startup, EasyRob shows a short **"EasyRob is opening..."** message so the user knows the app is starting.

### Uninstall

Remove EasyRob from:

- *Settings* -> *Apps* -> *Installed apps*

---

## Linux

### Option A: Debian package

Recommended for **Ubuntu** and Debian-based systems.

1. Download `easyrob-<VERSION>.deb`.
2. Install it with:

```bash
sudo dpkg -i easyrob-<VERSION>.deb
```

3. Open **EasyRob** from the applications menu.
4. Open **EasyRob** from the applications menu, the desktop shortcut, or by running `easyrob`.

### Option B: Shell installer

Useful for manual testing or direct installation from the repository.

1. Make the installer executable:

```bash
chmod +x packaging/linux/scripts/install_easyrob.sh
```

2. Run it:

```bash
./packaging/linux/scripts/install_easyrob.sh
```

3. Open EasyRob from the applications menu, the desktop shortcut, or:

```bash
~/.local/share/easyrob/bin/easyrob
```

### Notes

- Linux uses a **private user-local environment** under:

```text
~/.local/share/easyrob
```

- The current shell installer creates:
  - an application entry in `~/.local/share/applications`
  - a desktop shortcut in `~/Desktop` when that folder exists
  - logs in `~/.local/share/easyrob/logs`

- The current `.deb` installer creates:
  - a global runtime under `/opt/easyrob`
  - a launcher at `/usr/bin/easyrob`
  - an application entry in `/usr/share/applications`
  - a desktop shortcut for the installing user when the desktop directory can be resolved

### Uninstall

If installed with the `.deb` package:

```bash
sudo dpkg -r easyrob
```

If installed with the shell installer:

```bash
./packaging/linux/scripts/uninstall_easyrob.sh
```

---

## What Users Need To Know

**EasyRob does not depend on a preconfigured Python or Conda installation.**

EasyRob installs and uses its own private environment so it does not interfere with the user's existing setup.

---

## For Developers

The packaging workspace is separated by platform:

```text
Easyrob/
|-- packaging/
|   |-- shared/
|   |-- windows/
|   `-- linux/
|-- docs/
|-- dist/
`-- build_installer.ps1
```

Useful documents:

- [Packaging overview](docs/packaging.md)
- [Windows packaging](docs/packaging-windows.md)
- [Linux packaging](docs/packaging-linux.md)

### Source of truth

- Shared dependency definition: `packaging/shared/env.yaml`

### Build outputs

- Windows installer: `dist/windows/easyrob-<VERSION>.exe`
- Linux Debian package: `dist/linux/easyrob-<VERSION>.deb`

### Windows build

```powershell
.\build_installer.ps1
```

### Linux `.deb` build

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```
