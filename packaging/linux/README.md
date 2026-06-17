# EasyRob Linux Packaging

This folder contains the Linux-specific installer assets for EasyRob.

The first target is a lightweight installer script that:

- downloads Micromamba
- creates a private environment for EasyRob
- writes a launcher
- optionally creates a desktop entry

The shared environment source lives in:

- `packaging/shared/env.yaml`

The detailed rationale and workflow are documented in:

- [Linux packaging](C:/Users/CSIC/OneDrive/Escritorio/TheAlegreGroup/PhD/Easyrob/docs/packaging-linux.md)
