# 🚀 EasyRob

*EasyRob* includes guided installers for **Windows** and **Linux**, plus a prepared **macOS packaging scaffold**.

The goal is simple:

✅ Download EasyRob
✅ Install EasyRob
✅ Open EasyRob

No manual Python setup. No Conda configuration. No environment management.

---

# 📥 Downloads

| Platform                   | Package                 |
| -------------------------- | ----------------------- |
| 🪟 Windows                 | `easyrob-<VERSION>.exe` |
| 🐧 Linux (Ubuntu / Debian) | `easyrob-<VERSION>.deb` |
| 🍎 macOS                   | `easyrob-<VERSION>.dmg` |

---

# 🪟 Windows

## Installation

1. Download `easyrob-<VERSION>.exe`
2. Double-click the installer
3. Follow the setup wizard
4. Launch **EasyRob** from:

   * Start Menu
   * Windows Search
   * Desktop shortcut (if enabled)

---

# 🐧 Linux

## Installation

Recommended for **Ubuntu** and other Debian-based distributions.

1. Download `easyrob-<VERSION>.deb`
2. Double-click the downloaded package
3. Install EasyRob using your system's package installer
4. Launch **EasyRob** from:

   * Applications menu
   * Desktop shortcut (when available)

### Alternative Terminal Installation

```bash
sudo apt install ./easyrob-<VERSION>.deb
```

## What Gets Installed

* Runtime: `/opt/easyrob`
* Launcher: `/usr/bin/easyrob`
* Application entry: `/usr/share/applications`
* Desktop shortcut (when supported)

---

# 🍎 macOS

## Planned Installation Flow

The macOS packaging structure is now prepared in the workspace.

Target user flow:

1. Download `easyrob-<VERSION>.dmg`
2. Open the disk image
3. Install or drag **EasyRob.app**
4. Launch **EasyRob** from:

   * Applications
   * Launchpad
   * Spotlight

## Current Status

The repository already includes:

* a dedicated `packaging/macos/` folder
* a first `.app` scaffold
* a macOS launcher script
* a dedicated macOS packaging document

The final `.dmg` must be built on a real Mac.

---

# 📝 Notes

* EasyRob installs its own **private runtime**
* No Python installation is required
* No Conda installation is required
* The first installation may take a few minutes
* The first launch may be slightly slower while the environment is prepared
* During startup, EasyRob displays an **"EasyRob is opening..."** message so you know the application is launching

---

# ℹ️ What You Need To Know

EasyRob is completely self-contained.

✅ No Python installation required
✅ No Conda installation required
✅ No interference with existing environments

EasyRob installs and manages its own private runtime so it can run independently of your system configuration.

---

# 👨‍💻 Developer Information

## Project Structure

```text
EasyRob/
├── packaging/
│   ├── shared/
│   ├── windows/
│   ├── linux/
│   └── macos/
├── docs/
├── dist/
└── build_installer.ps1
```

## Documentation

* `docs/packaging.md`
* `docs/packaging-windows.md`
* `docs/packaging-linux.md`
* `docs/packaging-macos.md`

## Source of Truth

```text
packaging/shared/env.yaml
```

## Build Outputs

### Windows

```text
dist/windows/easyrob-<VERSION>.exe
```

### Linux

```text
dist/linux/easyrob-<VERSION>.deb
```

### macOS

```text
dist/macos/easyrob-<VERSION>.dmg
```

## Build Commands

### Windows

```powershell
.\build_installer.ps1
```

### Linux

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

### macOS

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```
