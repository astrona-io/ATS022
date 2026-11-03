# Control Which Volume A Claim Binds — Playground

- **Slug:** ats-022-playground-030-03
- **Type:** Astrona playground — clean environment, no task, no grading
- **Status:** UNTESTED (static checks only)

A single-node kind cluster (`kindest/node:v1.35.8`) with three static hostPath PVs (`crate-a` 200Mi `tier=slow`, `crate-b` 200Mi `tier=fast`, `vault-1` 2Gi with no label), all with the class name `manual`, and the Pending claim `manifest` in `starfleet`.

```sh
astrona run -c .
astrona destroy ats-022-playground-030-03
```

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/volumes.yaml` | Namespace, PVs and the Pending claim |
| `docs/overview.md` | What the environment contains and ideas to try |
