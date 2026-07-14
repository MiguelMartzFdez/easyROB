# EasyRob Windows Packaging

This document explains how to generate and maintain the Windows installer.

## Output

```text
dist/windows/easyrob-<VERSION>.exe
```

## Build command

From the repository root:

```powershell
.\packaging\windows\build.ps1
```

## Build requirements

- Windows
- Inno Setup 6 or 7
- `packaging/windows/assets/micromamba-win-64.exe`
- `packaging/shared/env.yaml`

## Source of truth

Windows packaging is driven by:

```text
packaging/shared/env.yaml
packaging/shared/version.txt
```

If dependencies or the release version change, edit those shared files first.

## Relevant files

- `packaging/windows/build.ps1`
- `packaging/windows/EasyRob.iss`
- `packaging/windows/assets/`
- `packaging/windows/scripts/install_easyrob.ps1`
- `packaging/windows/scripts/launch_easyrob.pyw`
- `packaging/windows/scripts/uninstall_easyrob.ps1`

## What the installer does

1. Copies the bundled Micromamba runtime
2. Creates the EasyRob environment from `packaging/shared/env.yaml`
3. Retries environment creation up to three attempts if a transient download failure occurs
4. Validates the runtime
5. Creates Start Menu entries
6. Optionally creates a Desktop shortcut

## User experience

After installation, EasyRob should be available from:

- Start Menu
- Windows Search
- Desktop shortcut, if enabled

When startup takes a moment, the launcher shows an opening message so the user does not click repeatedly.

## Runtime location

The private runtime is created here:

```text
%LOCALAPPDATA%\Programs\EasyRob\micromamba\envs\easyrob
```

## Log location

Installer logs are written under:

```text
%LOCALAPPDATA%\Programs\EasyRob\logs
```

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
.\packaging\windows\build.ps1
```

### Dependency changes

1. Edit `packaging/shared/env.yaml`
2. Rebuild the installer
3. Test a clean install on Windows
