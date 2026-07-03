# 🚀 easyROB

**EasyRob** provides simple desktop installers that prepare and launch a fully private runtime environment for the application.

<p align="center">
  <img src="docs/assets/easyROB_logo.png" width="180" alt="EasyRob Logo">
</p>

---

## 📦 Download EasyRob

| Platform | Download |
| --- | --- |
| 💻 Windows | [![Download for Windows](https://img.shields.io/badge/Download-Windows-0078D4?style=for-the-badge&logo=windows)](../../releases/latest/download/easyrob-latest.exe) |
| 🐧 Linux (Ubuntu/Debian) | [![Download for Linux](https://img.shields.io/badge/Download-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](../../releases/latest/download/easyrob-latest.deb) |
| 🍎 macOS | [![Download for macOS](https://img.shields.io/badge/Download-macOS-000000?style=for-the-badge&logo=apple)](../../releases/latest/download/easyrob-latest.dmg) |

---

# 👤 For Users

---

## Installation

## 💻 Windows

1. Download `easyrob-2.1.6.exe`.
2. Double-click the installer.
3. If **Windows protected your PC** appears:
   - Click **More info**.
   - Click **Run anyway**.
4. Follow the installation wizard.
5. Launch **easyROB** from:
   - the **Start Menu**
   - **Windows Search**
   - or the **Desktop shortcut** (if selected during installation)

### Uninstall

easyROB can be removed like any other Windows application:

1. Open **Settings** → **Apps** → **Installed apps** (or **Apps & features** on older Windows versions).
2. Select **easyROB**.
3. Click **Uninstall** and follow the prompts.

---

## 🍎 macOS

1. Download `easyrob-2.1.6.dmg`.
2. Open the downloaded disk image.
3. Drag **EasyRob.app** into the **Applications** folder.
4. Open **EasyRob**.

If macOS reports that **EasyRob** is from an unidentified developer:

1. Click **Done** (do **not** move the application to the Trash).
2. Open the **Applications** folder.
3. Right-click **EasyRob.app** and select **Open**.
4. Click **Open** in the confirmation dialog.

> **Important**
>
> Due to macOS sandbox permissions, it is recommended to work inside the **workspace** folder automatically created by EasyRob.

### Uninstall

To completely remove EasyRob:

```bash
bash "$HOME/Library/ApplicationSupport/EasyRob/uninstall_easyrob.sh"
```

---

## 🐧 Linux (Ubuntu / Debian)

1. Download `easyrob-2.1.6.deb`.
2. Double-click the package.
3. If your system warns that the package is provided by a third party, click **Install**.
4. Launch **easyROB** from:
   - the **Applications menu**
   - the **Desktop shortcut** (if available)

> **Note**
>
> Ubuntu may display a warning because the package is distributed outside the official repositories. If you downloaded it from the official GitHub Releases page, it is safe to continue.

### Install or update from the terminal

```bash
sudo dpkg -i easyrob-2.1.6.deb
```

### Uninstall

```bash
easyrob --uninstall
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
└── dist/
```

---

## 📦 Build Outputs

| Platform   | Output                               |
| ---------- | ------------------------------------ |
| 🪟 Windows | `dist/windows/easyrob-<VERSION>.exe` |
| 🐧 Linux   | `dist/linux/easyrob-<VERSION>.deb`   |
| 🍎 macOS   | `dist/macos/easyrob-<VERSION>.dmg`   |

---

# 🖥️ Build Hosts

Each installer is generated on its own operating system.

| Target package                        | Build host |
| ------------------------------------- | ---------- |
| `easyrob-<VERSION>.exe`               | Windows    |
| `easyrob-<VERSION>.deb`               | Linux      |
| `easyrob-<VERSION>.dmg` | macOS      |

You do **not** build all three final artifacts from Windows.

What is shared across all of them is:

- `packaging/shared/env.yaml`
- the same repository
- the same packaging structure

---

# 🔨 Building Packages

## 🪟 Windows

```powershell
.\packaging\windows\build.ps1
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
* macOS 11 Big Sur or newer
* `rsync`
* `hdiutil`
* `codesign`
* `grep`
* `sed`

### Output

This build creates:

- `dist/macos/easyrob-<VERSION>.dmg`

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
