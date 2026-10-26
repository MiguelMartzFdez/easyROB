# Shared Packaging Inputs

This folder contains the packaging inputs shared by Windows, Linux, and macOS.

## Main file

```text
packaging/shared/env.yaml
```

This defines the shared Conda and pip dependencies. ROBERT itself is bundled as
one wheel in `packaging/shared/assets/` and installed from that file by each
platform installer. AQME still comes from its GitHub `master` branch, so
runtime creation still needs network access for AQME and other dependencies.

To refresh the bundled ROBERT wheel from the local `robert` Conda environment,
run from the repository root:

```powershell
conda run -n robert python packaging/shared/package_robert.py
```

The script reads the ROBERT source imported by that environment, builds a
portable wheel, and replaces the previous ROBERT wheel in `assets/`. Run it
again whenever that local source changes before rebuilding installers.

## Rule

If the application runtime changes:

1. edit `packaging/shared/env.yaml` for dependencies or refresh the bundled ROBERT wheel
2. rebuild the installer or package for the platform you want to ship
3. test a clean install on that platform

Platform-specific support files can still exist in each packaging folder, but they should not replace `env.yaml` as the main editable definition.
