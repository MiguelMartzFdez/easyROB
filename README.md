# 🚀 EasyRob

*EasyRob* includes guided installers for **Windows** and **Linux**.

The goal is simple:

✅ Download EasyRob
✅ Install EasyRob
✅ Open EasyRob

No manual Python setup. No Conda configuration. No environment management.

---

# 📦 Available Packages

| Platform                   | Package                       |
| -------------------------- | ----------------------------- |
| 🪟 Windows                 | `easyrob-<VERSION>.exe` |
| 🐧 Linux (Ubuntu / Debian) | `easyrob-<VERSION>.deb`   |

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

## Notes

* EasyRob installs its own **private runtime**
* No Python installation is required
* No Conda installation is required
* The first installation may take a few minutes
* The first launch may be slightly slower while the environment is prepared
* During startup, EasyRob displays an **"EasyRob is opening..."** message so you know the application is launching

## Uninstall

Open:

**Settings → Apps → Installed Apps**

Then select **EasyRob** and click **Uninstall**.

---

# 🐧 Linux

## Option A — Debian Package (Recommended)

Recommended for Ubuntu and other Debian-based distributions.

### Installation

1. Download `easyrob-<VERSION>.deb`

2. Install it:

```bash
sudo apt install ./easyrob-<VERSION>.deb
```

3. Launch EasyRob from:

   * Applications menu
   * Desktop shortcut (when available)
   * Terminal:

```bash
easyrob
```

### What Gets Installed

* Runtime: `/opt/easyrob`
* Launcher: `/usr/bin/easyrob`
* Application entry: `/usr/share/applications`
* Desktop shortcut (when supported)

---

## Option B — Shell Installer

Useful for testing or installing directly from the repository.

### Installation

Make the installer executable:

```bash
chmod +x packaging/linux/scripts/install_easyrob.sh
```

Run it:

```bash
./packaging/linux/scripts/install_easyrob.sh
```

Launch EasyRob:

```bash
~/.local/share/easyrob/bin/easyrob
```

Or open it from your Applications menu.

### What Gets Installed

EasyRob creates a private user environment under:

```text
~/.local/share/easyrob
```

It also creates:

* Application entry in `~/.local/share/applications`
* Desktop shortcut in `~/Desktop` (when available)
* Log files in `~/.local/share/easyrob/logs`

---

# 🗑️ Uninstall

## Debian Package

```bash
sudo dpkg -r easyrob
```

## Shell Installer

```bash
./packaging/linux/scripts/uninstall_easyrob.sh
```

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
