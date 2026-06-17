# EasyRob Installer Build Notes

This document describes how the Windows installer is structured, how it is built, and how to maintain the bundled runtime.

## Output

The only file distributed to end users is:

```text
dist\EasyRob-Setup-<VERSION>.exe
```

Users do not need Python, Conda, or Miniforge preinstalled.

## Project structure

```text
exe_env_robert\
|-- README.md
|-- INSTALLER.md
|-- build_installer.ps1
|-- dist\
|   `-- EasyRob-Setup-<VERSION>.exe
`-- installer\
    |-- EasyRob.iss
    |-- assets\
    |   |-- Miniforge3-Windows-x86_64.exe
    |   `-- Robert_icon.ico
    |-- locks\
    |   |-- conda-explicit.txt
    |   `-- requirements.txt
    |-- scripts\
    |   |-- install_easyrob.ps1
    |   |-- launch_easyrob.pyw
    |   `-- uninstall_easyrob.ps1
    `-- source\
        `-- env.yaml
```

## File responsibilities

- `installer\EasyRob.iss`: main Inno Setup script.
- `installer\assets\`: bundled assets embedded into the final setup.
- `installer\locks\conda-explicit.txt`: exact Conda package list used to create the `easyrob` environment.
- `installer\locks\requirements.txt`: exact pip package list installed after the Conda environment is created.
- `installer\scripts\install_easyrob.ps1`: installs Miniforge, creates the locked Conda environment, installs pip packages, validates the runtime, and writes logs.
- `installer\scripts\launch_easyrob.pyw`: launches EasyRob with the private bundled environment and no console window.
- `installer\scripts\uninstall_easyrob.ps1`: removes the private runtime during uninstall.
- `installer\source\env.yaml`: editable source definition used to regenerate the lock files. The installer does not consume it directly.
- `build_installer.ps1`: validates the required files, locates Inno Setup, and compiles the installer.

## Installation model

The installer consumes two lock files instead of solving directly from `env.yaml` on the user machine:

1. `conda-explicit.txt`
2. `requirements.txt`

This gives the user a fixed Windows environment and avoids a fresh Conda solve during installation.

## Build requirements

1. 64-bit Windows
2. Inno Setup 6 or 7
3. All files under `installer\`

## Build command

From the project root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\build_installer.ps1
```

If local script execution is already allowed:

```powershell
.\build_installer.ps1
```

The generated installer is written to:

```text
dist\EasyRob-Setup-<VERSION>.exe
```

## What the installer does

1. Installs Miniforge silently into `%LOCALAPPDATA%\Programs\EasyRob\miniforge`
2. Creates a local Conda environment named `easyrob` from `installer\locks\conda-explicit.txt`
3. Installs pip packages from `installer\locks\requirements.txt`
4. Validates the private EasyRob launcher
5. Creates a Start Menu shortcut
6. Optionally creates a Desktop shortcut
7. Does not modify the system `PATH`
8. Does not register Python globally
9. Does not auto-launch EasyRob at the end of setup

The environment is stored at:

```text
<INSTALL_DIR>\miniforge\envs\easyrob
```

Only the private EasyRob runtime is touched. Existing Conda installations and user environments are not modified.

## Update behavior

The installer uses a fixed `AppId` and a fixed default install location:

```text
%LOCALAPPDATA%\Programs\EasyRob
```

Running the installer again does not create a parallel versioned install. It reinstalls or updates in place.

Before dependency installation, the private EasyRob runtime is removed and rebuilt. In practice, a new installer run replaces the existing bundled environment in the same location.

## Installation time and disk usage

- Installation can take 5 to 10 minutes on some systems.
- The installer requires at least 4 GB of free disk space.
- The first launch can also be slower while Windows finishes preparing and scanning the new environment.

## Cancellation and recovery

During dependency installation, the Inno Setup window keeps `Cancel` available.

If the user cancels:

1. The active dependency process tree is stopped
2. Only the private EasyRob runtime is removed
3. Logs from that cancelled attempt are removed
4. External Python or Conda installations are left untouched

If installation fails:

1. The partial private runtime is removed
2. Diagnostic logs are preserved
3. The installer shows the log folder and support email
4. The installer exits

## Logs

During installation, logs are written to:

```text
<INSTALL_DIR>\logs\miniforge-install.log
<INSTALL_DIR>\logs\miniforge-install-error.log
<INSTALL_DIR>\logs\conda-environment.log
<INSTALL_DIR>\logs\conda-environment-error.log
<INSTALL_DIR>\logs\pip-install.log
<INSTALL_DIR>\logs\pip-install-error.log
<INSTALL_DIR>\logs\installer-summary.log
<INSTALL_DIR>\logs\installer-error.log
```

`installer-summary.log` includes:

- Start time
- End time
- Total installation duration
- Duration of each phase

## Launching EasyRob

The shortcuts run:

```text
<INSTALL_DIR>\miniforge\envs\easyrob\pythonw.exe
    <INSTALL_DIR>\launch_easyrob.pyw
```

The launcher configures only the private EasyRob environment before starting the GUI. No manual Conda activation is required, and no console window is shown.

## Uninstall

EasyRob can be removed from `Settings > Apps > Installed apps` or by running:

```text
%LOCALAPPDATA%\Programs\EasyRob\unins000.exe
```

Uninstallation removes:

- The private Miniforge distribution
- The `easyrob` environment
- Installer logs
- EasyRob shortcuts

External Python and Conda installations are not touched.

## Maintaining lock files

`installer\source\env.yaml` is the editable source definition.

Typical maintenance workflow:

1. Create a clean environment from `installer\source\env.yaml`
2. Export the exact Conda package list to `installer\locks\conda-explicit.txt`
3. Export the pip package list to `installer\locks\requirements.txt`
4. Rebuild the installer

The installer itself should consume only the files under `installer\locks\`.

### Regenerating `conda-explicit.txt` and `requirements.txt`

Example workflow from the project root:

```powershell
conda env remove -n easyrob-lock -y
conda env create -n easyrob-lock -f .\installer\source\env.yaml
conda activate easyrob-lock
conda list --explicit > .\installer\locks\conda-explicit.txt
pip list --format=freeze > .\installer\locks\requirements.txt
conda deactivate
```

Notes:

- Use a temporary environment name such as `easyrob-lock` so you do not touch a personal environment.
- `conda list --explicit` must be run from inside the prepared environment.
- `pip list --format=freeze` is preferred over `pip freeze` so local build paths are not written into the lock file.
- The resulting files are Windows-specific lock files intended for this installer.

After regenerating the lock files:

1. Review `installer\locks\requirements.txt` for unexpected pip packages
2. Keep `installer\source\env.yaml` as the editable source of truth
3. Rebuild the installer with `build_installer.ps1`
