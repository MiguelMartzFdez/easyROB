# 🚀 EasyRob

*EasyRob* includes guided installers for **Windows** and **Linux**.

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
│   └── linux/
├── docs/
├── dist/
└── build_installer.ps1
```

## Documentation

* `docs/packaging.md`
* `docs/packaging-windows.md`
* `docs/packaging-linux.md`

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
