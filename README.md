# EasyRob

EasyRob provides desktop installers that prepare and launch a private runtime for the application.

Today the user-ready installers are:

- `easyrob-<VERSION>.exe` for Windows
- `easyrob-<VERSION>.deb` for Ubuntu and Debian-based Linux

The repository also includes the macOS bootstrap-app packaging that produces:

- `EasyRob.app`
- `easyrob-<VERSION>.zip`

## For Users

### Windows

1. Download `easyrob-<VERSION>.exe`
2. Double-click the installer
3. Follow the setup wizard
4. Open **EasyRob** from the Start Menu, Windows Search, or the Desktop shortcut if enabled

### Linux

Recommended for Ubuntu and other Debian-based distributions.

1. Download `easyrob-<VERSION>.deb`
2. Double-click the package and install it with the system package installer
3. Open **EasyRob** from the applications menu or the desktop shortcut when available

Alternative terminal install:

```bash
sudo apt install ./easyrob-<VERSION>.deb
```

### macOS

Build this on a real Mac, then distribute the generated zip.

User flow:

1. Download `easyrob-<VERSION>.zip`
2. Unzip it
3. Move `EasyRob.app` to `Applications`
4. Open **EasyRob** from Applications, Launchpad, or Spotlight
5. On first launch, EasyRob installs Micromamba and creates its private runtime under `~/Library/Application Support/EasyRob`

## Runtime Behavior

- EasyRob installs its own private runtime
- No separate Python installation is required
- No separate Conda installation is required
- Installation can take a few minutes
- First launch can also take a bit longer
- When launch is slow, EasyRob shows an opening message so the user knows the application is starting

## For Maintainers

### Source of truth

Shared dependencies are defined in:

```text
packaging/shared/env.yaml
```

If EasyRob dependencies change, edit that file first.

### Packaging layout

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

### Build outputs

- Windows: `dist/windows/easyrob-<VERSION>.exe`
- Linux: `dist/linux/easyrob-<VERSION>.deb`
- macOS: `dist/macos/EasyRob.app` and `dist/macos/easyrob-<VERSION>.zip`

### Build commands

Windows:

```powershell
.\build_installer.ps1
```

Linux:

```bash
chmod +x packaging/linux/build-deb.sh
./packaging/linux/build-deb.sh
```

macOS:

```bash
chmod +x packaging/macos/build.sh
./packaging/macos/build.sh
```

### What to change when EasyRob is updated

If only installer behavior changed, update only the platform-specific packaging files:

- `packaging/windows/...`
- `packaging/linux/...`
- `packaging/macos/...`
- `docs/...`

If dependencies changed:

1. Edit `packaging/shared/env.yaml`
2. Rebuild the installer or package for the platform you want to ship
3. Test a clean install on that platform

## Documentation

- [Packaging overview](docs/packaging.md)
- [Windows packaging](docs/packaging-windows.md)
- [Linux packaging](docs/packaging-linux.md)
- [macOS packaging](docs/packaging-macos.md)
