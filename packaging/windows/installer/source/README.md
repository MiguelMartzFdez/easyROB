# Windows Source Notes

Windows packaging uses the shared dependency definition:

```text
packaging/shared/env.yaml
```

Windows-specific installer behavior lives in:

- `packaging/windows/installer/EasyRob.iss`
- `packaging/windows/installer/scripts/`
- `packaging/windows/installer/assets/`

The `locks/` folder can still contain Windows-specific support snapshots, but the main editable dependency file is `packaging/shared/env.yaml`.
