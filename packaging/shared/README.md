# Shared Packaging Inputs

This folder contains the packaging inputs shared by Windows, Linux, and macOS.

## Main file

```text
packaging/shared/env.yaml
```

This is the dependency source of truth for EasyRob.

ROBERT and AQME are installed from the `master` branches of their GitHub
repositories. Creating the runtime therefore requires internet access to GitHub
as well as the package indexes and Conda channels. The Git dependency in
`env.yaml` lets pip fetch both repositories on every supported platform.

## Rule

If the application runtime changes:

1. edit `packaging/shared/env.yaml`
2. rebuild the installer or package for the platform you want to ship
3. test a clean install on that platform

Platform-specific support files can still exist in each packaging folder, but they should not replace `env.yaml` as the main editable definition.
