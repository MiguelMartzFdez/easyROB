# EasyRob Windows Packaging

This document describes how the Windows installer is structured, how it is built, and how to maintain the bundled runtime.

## Output

The only file distributed to end users is:

`dist\windows\easyrob-<VERSION>.exe`

Users do not need Python, Conda, or Miniforge preinstalled.

## Project structure

```text
Easyrob\
|-- packaging\
|   |-- shared\
|   |   `-- env.yaml
|   `-- windows\
|       |-- build.ps1
|       `-- installer\
|           |-- EasyRob.iss
|           |-- assets\
|           |-- scripts\
|           `-- source\
`-- dist\
    `-- windows\
        `-- easyrob-<VERSION>.exe
```

## File responsibilities

- `packaging\windows\installer\EasyRob.iss`: main Inno Setup script.
- `packaging\windows\installer\assets\`: bundled assets embedded into the final setup.
- `packaging\windows\installer\scripts\install_easyrob.ps1`: installs Miniforge, creates the EasyRob environment from the shared `env.yaml`, validates the runtime, and writes logs.
- `packaging\windows\installer\scripts\launch_easyrob.pyw`: launches EasyRob with the private bundled environment and no console window.
- `packaging\windows\installer\scripts\uninstall_easyrob.ps1`: removes the private runtime during uninstall.
- `packaging\shared\env.yaml`: editable source definition used by Windows, Linux, and macOS packaging.
- `packaging\windows\installer\source\README.md`: explains that Windows consumes the shared source definition.
- `packaging\windows\build.ps1`: validates the required files, locates Inno Setup, and compiles the installer.
- `build_installer.ps1`: compatibility wrapper that calls `packaging\windows\build.ps1`.

## Installation model

The installer creates the EasyRob runtime directly from:

- `packaging\shared\env.yaml`

That keeps Windows aligned with the current Linux and planned macOS packaging model.

## Build requirements

1. 64-bit Windows
2. Inno Setup 6 or 7
3. All files under `packaging\windows\installer\`

## Build command

From the project root:

`powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\build_installer.ps1`

If local script execution is already allowed:

`.\build_installer.ps1`

The generated installer is written to:

`dist\windows\easyrob-<VERSION>.exe`

## What the installer does

1. Installs Miniforge silently into `%LOCALAPPDATA%\Programs\EasyRob\miniforge`
2. Creates a local Conda environment named `easyrob` from `packaging\shared\env.yaml`
3. Installs the shared dependency set for EasyRob
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

## Maintaining dependencies

`packaging\shared\env.yaml` is the editable source definition.

When EasyRob dependencies change, this is the file you edit first.

Typical maintenance workflow:

1. Edit `packaging\shared\env.yaml`
2. Rebuild the installer
3. Test a fresh Windows installation

## Windows update checklist

### If only the installer changed

1. edit the relevant files under `packaging\windows\installer\`
2. run `.\build_installer.ps1`

### If dependencies changed

1. edit `packaging\shared\env.yaml`
2. run `.\build_installer.ps1`
3. verify a clean install on Windows
