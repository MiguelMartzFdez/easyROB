# Shared Packaging Inputs

This folder contains the cross-platform packaging inputs that should be edited in one place.

- `env.yaml`: common Conda environment definition used to generate platform-specific locks.

Platform-specific `locks/` folders must remain separate because final lock outputs are operating-system specific.
