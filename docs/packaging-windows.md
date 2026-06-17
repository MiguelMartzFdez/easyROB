# EasyRob Windows Packaging

This document explains how to generate and maintain the Windows installer.

## Output

```text
dist/windows/easyrob-<VERSION>.exe
```

## Build command

From the repository root:

```powershell
.\build_installer.ps1
```

That wrapper calls:

```text
packaging/windows/build.ps1
```

## Source of truth

Windows packaging is driven by:

```text
packaging/shared/env.yaml
```

If dependencies change, edit that file first.

## Relevant files

- `packaging/windows/build.ps1`
- `packaging/windows/installer/EasyRob.iss`
- `packaging/windows/installer/assets/`
- `packaging/windows/installer/scripts/install_easyrob.ps1`
- `packaging/windows/installer/scripts/launch_easyrob.pyw`
- `packaging/windows/installer/scripts/uninstall_easyrob.ps1`
- `packaging/windows/installer/source/README.md`

## What the installer does

1. Installs the bundled Miniforge runtime
2. Creates the EasyRob environment from `packaging/shared/env.yaml`
3. Validates the runtime
4. Creates Start Menu entries
5. Optionally creates a Desktop shortcut

## User experience

After installation, EasyRob should be available from:

- Start Menu
- Windows Search
- Desktop shortcut, if enabled

When startup takes a moment, the launcher shows an opening message so the user does not click repeatedly.

## When to update Windows packaging

### Installer-only changes

Change Windows packaging files only when you are updating:

- setup text
- shortcut behavior
- launch message behavior
- uninstall behavior
- installer branding or assets

Then rebuild the installer:

```powershell
.\build_installer.ps1
```

### Dependency changes

1. Edit `packaging/shared/env.yaml`
2. Rebuild the installer
3. Test a clean install on Windows

## Notes about locks

The repository still contains:

- `packaging/windows/installer/locks/conda-explicit.txt`
- `packaging/windows/installer/locks/requirements.txt`

Treat them as Windows-specific support artifacts, not as the main editable dependency definition.
