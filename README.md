# 🚀 EasyRob

**EasyRob** provides simple desktop installers that prepare and launch a fully private runtime environment for the application.

<p align="center">
  <img src="docs/assets/easyROB_logo.png" width="180" alt="EasyRob Logo">
</p>

---

## 📦 Available Installers

| Platform                 | Package                                 |
| ------------------------ | --------------------------------------- |
| 🪟 Windows               | `easyrob-<VERSION>.exe`                 |
| 🐧 Linux (Ubuntu/Debian) | `easyrob-<VERSION>.deb`                 |
| 🍎 macOS                 | `EasyRob.app` + `easyrob-<VERSION>.zip` |

---

# 👤 For Users

## 🪟 Windows

1. Download the installer from **[GitHub Releases](https://github.com/MiguelMartzFdez/EasyRob/releases/)**.
2. Download `easyrob-<VERSION>.exe`
3. Double-click the installer
4. Follow the setup wizard
5. Launch **EasyRob** from:

   * Start Menu
   * Windows Search
   * Desktop Shortcut (optional)

---

## 🐧 Linux

Recommended for Ubuntu and Debian-based distributions.

### Graphical Installation

1. Download the package from **[GitHub Releases](https://github.com/MiguelMartzFdez/EasyRob/releases/)**.
2. Download `easyrob-<VERSION>.deb`
3. Open it with your system package installer
4. Launch **EasyRob** from:

   * Applications Menu
   * Desktop Shortcut (if available)

---

## 🍎 macOS

1. Download the latest macOS release from **[GitHub Releases](https://github.com/MiguelMartzFdez/EasyRob/releases/)**.
2. Download `easyrob-<VERSION>.zip`
3. Extract the archive
4. Move `EasyRob.app` into `/Applications`
5. Open **EasyRob** using:

   * Applications
   * Launchpad
   * Spotlight
  
---

## 🔧 First Launch

EasyRob automatically:

* 📥 Installs Micromamba
* 🐍 Creates its private runtime
* ⚙️ Configures required dependencies

Runtime files are stored in:

```text
~/Library/Application Support/EasyRob
```

---

# ⚡ Runtime Behavior

EasyRob manages everything automatically.

✅ No Python installation required

✅ No Conda installation required

✅ Fully isolated runtime

⏳ Initial installation may take a few minutes

⏳ First launch may be slower while the environment is prepared

💬 A startup message is displayed during longer launches

---

# 🛠️ For Maintainers

## 📍 Source of Truth

Shared dependencies are defined in:

```text
packaging/shared/env.yaml
```

When dependencies change, update this file first.

---

## 📂 Packaging Layout

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

---

## 📦 Build Outputs

| Platform   | Output                               |
| ---------- | ------------------------------------ |
| 🪟 Windows | `dist/windows/easyrob-<VERSION>.exe` |
| 🐧 Linux   | `dist/linux/easyrob-<VERSION>.deb`   |
| 🍎 macOS   | `dist/macos/EasyRob.app`             |
| 🍎 macOS   | `dist/macos/easyrob-<VERSION>.zip`   |

---

# 🔨 Building Packages

## 🪟 Windows

```powershell
.\build_installer.ps1
```

### Requirements

* Windows
* Inno Setup 6 or 7
* `packaging/windows/assets/Miniforge3-Windows-x86_64.exe`

---

## 🐧 Linux

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

### Requirements

* Linux
* `dpkg-deb`
* `install`
* `grep`
* `sed`
* `packaging/linux/assets/micromamba-linux-64`

---

## 🍎 macOS

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

### Requirements

* A real Mac
* `rsync`
* `ditto`
* `grep`
* `sed`

---

# 🔄 Updating EasyRob

## Only Packaging Changes

Update:

```text
packaging/windows/
packaging/linux/
packaging/macos/
docs/
```

No dependency rebuild required.

---

## Dependency Changes

1. Edit:

```text
packaging/shared/env.yaml
```

2. Rebuild the installer/package

3. Test on a clean machine

---

# 📚 Documentation

* 📘 Packaging Overview → `docs/packaging.md`
* 🪟 Windows Packaging → `docs/packaging-windows.md`
* 🐧 Linux Packaging → `docs/packaging-linux.md`
* 🍎 macOS Packaging → `docs/packaging-macos.md`

---
