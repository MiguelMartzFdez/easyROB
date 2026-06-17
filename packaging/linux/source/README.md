# Linux Source Notes

Linux packaging uses the shared dependency definition:

```text
packaging/shared/env.yaml
```

Linux-specific packaging behavior lives in:

- `packaging/linux/build-deb.sh`
- `packaging/linux/scripts/`

Use `packaging/linux/locks/` only if a future Linux-specific snapshot is needed.
