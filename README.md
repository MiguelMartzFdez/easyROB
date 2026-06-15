# EasyRob Windows Installer

This project builds a single Windows installer for EasyRob.

The only file that must be distributed to end users is:

```text
dist\EasyRob-Setup-<VERSION>.exe
```

End users do not need Python, Conda, or Miniforge installed in advance.

## Project structure

```text
exe_env_robert\
|-- README.md
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
- `installer\assets\`: bundled installer assets embedded into the final setup.
- `installer\locks\conda-explicit.txt`: exact Conda package list used to create the `easyrob` environment.
- `installer\locks\requirements.txt`: exact pip package list installed after the Conda environment is created.
- `installer\scripts\install_easyrob.ps1`: installs Miniforge, creates the locked Conda environment, installs pip packages, and writes logs.
- `installer\scripts\launch_easyrob.pyw`: launches EasyRob with the private bundled environment and no console window.
- `installer\scripts\uninstall_easyrob.ps1`: removes the private runtime during uninstall.
- `installer\source\env.yaml`: maintenance source file used to regenerate the lock files. The installer does not use it directly.
- `build_installer.ps1`: validates the required files, finds Inno Setup, and compiles the installer.

## Current installation model

The installer now uses two lock files instead of creating the environment directly from `env.yaml`:

1. `conda-explicit.txt`
2. `requirements.txt`

This means the end user gets a fixed Windows environment instead of a fresh Conda solve on every machine. That improves reproducibility and usually makes installation more predictable.

## Building the installer

Requirements for the build machine:

1. 64-bit Windows
2. Inno Setup 6 or 7
3. All files under `installer\`

Recommended command from the project root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\build_installer.ps1
```

If local script execution is already allowed, this also works:

```powershell
.\build_installer.ps1
```

The output is written to:

```text
dist\EasyRob-Setup-<VERSION>.exe
```

## Installation behavior

The installer:

1. installs Miniforge silently into `%LOCALAPPDATA%\Programs\EasyRob\miniforge`
2. creates a local Conda environment named `easyrob` from `installer\locks\conda-explicit.txt`
3. installs pip packages from `installer\locks\requirements.txt`
4. validates the private EasyRob launcher
5. creates a Start Menu shortcut
6. optionally creates a Desktop shortcut if the user selects that task
7. does not modify the system `PATH`
8. does not register Python globally
9. does not auto-launch EasyRob at the end of setup

The environment is stored at:

```text
<INSTALL_DIR>\miniforge\envs\easyrob
```

Only the private EasyRob runtime is touched. Existing Conda installations and user environments are not queried or modified.

## Installation time

On some systems, installation can take 5 to 10 minutes because Miniforge, the locked Conda environment, and the pip packages are installed locally inside the EasyRob folder.

The first launch of EasyRob can also take longer than usual while Windows finishes scanning and preparing the new environment.

The installer's free-disk-space check includes extra space for the local Miniforge installation and the generated `easyrob` environment, not just the compressed setup payload.

## Cancellation and recovery

During dependency installation, the main Inno Setup window stays in control and keeps **Cancel** available.

If the user cancels:

1. the active dependency process tree is stopped
2. only the private EasyRob runtime is removed
3. logs from that canceled attempt are removed
4. external Python or Conda installations are left untouched

If installation fails:

1. the partial private runtime is removed
2. diagnostic logs are preserved
3. the installer shows the log folder and support email
4. the installer exits

## Logs

When installation runs, logs are written to:

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

`installer-summary.log` contains:

- start time
- end time
- total installation duration
- duration of each installation phase

## Launching EasyRob

The shortcuts run:

```text
<INSTALL_DIR>\miniforge\envs\easyrob\pythonw.exe
    <INSTALL_DIR>\launch_easyrob.pyw
```

The launcher configures only the private EasyRob environment before starting the GUI. No manual Conda activation is required, and no console window is shown.

Users can start EasyRob from:

- the Start Menu
- Windows Search by typing `EasyRob`
- the Desktop shortcut, if they chose to create it

## Uninstalling

EasyRob can be removed from **Settings > Apps > Installed apps** or by running:

```text
%LOCALAPPDATA%\Programs\EasyRob\unins000.exe
```

Uninstallation removes:

- the private Miniforge distribution
- the `easyrob` environment
- installer logs
- EasyRob shortcuts

External Python and Conda installations are not touched.

## Maintaining the lock files

`installer\source\env.yaml` is kept as the editable source definition.

Typical maintenance workflow:

1. create a clean environment from `installer\source\env.yaml`
2. export the exact Conda package list to `installer\locks\conda-explicit.txt`
3. export the pip package list to `installer\locks\requirements.txt`
4. rebuild the installer

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

- use a temporary environment name such as `easyrob-lock` so you do not touch any existing personal environment
- `conda list --explicit` must be run from inside the prepared environment
- `pip list --format=freeze` should be used instead of `pip freeze` so local build paths do not get written into the lock file
- the resulting files are Windows-specific lock files intended for this installer

After regenerating the lock files:

1. review `installer\locks\requirements.txt` if you want to spot unexpected pip packages
2. keep `installer\source\env.yaml` as the editable source of truth
3. rebuild the installer with `build_installer.ps1`
