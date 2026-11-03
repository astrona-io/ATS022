# Resize A Persistent Volume Claim — Playground

- **Slug:** ats-022-playground-030-02
- **Type:** Astrona playground — clean environment, no task, no grading
- **Status:** UNTESTED (static checks only)

A single-node kind cluster (`kindest/node:v1.35.8`) with the StorageClasses `training-grow` (no expansion) and `training-expand` (`allowVolumeExpansion: true`), the 100Mi claims `data` and `logs` in `starfleet`, and the Deployment `data-writer` that mounts both.

```sh
astrona run -c .
astrona destroy ats-022-playground-030-02
```

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/storage.yaml` | Namespace, classes, claims and the Deployment |
| `docs/overview.md` | What the environment contains and ideas to try |
