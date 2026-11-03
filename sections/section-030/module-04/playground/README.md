# Mount Claims In Workloads And Protect Them — Playground

- **Slug:** ats-022-playground-030-04
- **Type:** Astrona playground — clean environment, no task, no grading
- **Status:** UNTESTED (static checks only)

A single-node kind cluster (`kindest/node:v1.35.8`) with the claim `old-claim` (50Mi, class `standard`) mounted by the Pod `holder`, and a headless Service `beacon-log`, all in `starfleet`.

```sh
astrona run -c .
astrona destroy ats-022-playground-030-04
```

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/workloads.yaml` | Namespace, Service, claim and Pod |
| `docs/overview.md` | What the environment contains and ideas to try |
