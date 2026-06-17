# EasyRob Packaging

This repository contains the packaging and installer assets for EasyRob.

The workspace is now organized by operating system so each platform can keep its own installer scripts, assets, locks, and release instructions.

## Layout

```text
Easyrob/
|-- packaging/
|   |-- shared/
|   |   |-- env.yaml
|   |   `-- README.md
|   |-- windows/
|   |   |-- build.ps1
|   |   `-- installer/
|   `-- linux/
|       |-- scripts/
|       |-- source/
|       `-- locks/
|-- docs/
|   |-- packaging.md
|   |-- packaging-windows.md
|   `-- packaging-linux.md
|-- dist/
`-- build_installer.ps1
```

## Current status

- `Windows`: implemented with Inno Setup and a private Miniforge-based runtime.
- `Linux`: initial lightweight installer structure prepared. The intended model is a small installer script that downloads Micromamba, creates the local environment, and writes a launcher.
- `Shared inputs`: the common environment definition now lives in `packaging/shared/env.yaml`, while `locks/` remain separate by platform.

## For developers

- [Packaging overview](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging.md)
- [Windows packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-windows.md)
- [Linux packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-linux.md)
