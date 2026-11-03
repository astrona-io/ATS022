# Diagnose Pending Claims And Provisioning Failures - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-022-playground-010-03
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED (static checks only)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) in which three claims in `starfleet` are Pending on purpose: one names a missing class, one uses a class with an unserved provisioner, one waits for its first consumer.

## Run it

```sh
astrona run -c .
astrona destroy ats-022-playground-010-03
```

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/start.yaml` | Namespaces, the `training-offline` class, three claims and two Pods |
| `docs/overview.md` | What the environment contains and ideas to try |
