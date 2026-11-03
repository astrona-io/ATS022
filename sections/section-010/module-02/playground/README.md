# Configure StorageClass Fields And The Default Class - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-022-playground-010-02
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED (static checks only)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with the default StorageClass `standard` (kind), a second class `training-fast`, the namespaces `starfleet` and `outpost` and a `probe` Deployment without storage.

## Run it

```sh
astrona run -c .
astrona destroy ats-022-playground-010-02
```

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/start.yaml` | Namespaces, the `training-fast` class and the `probe` Deployment |
| `docs/overview.md` | What the environment contains and ideas to try |
