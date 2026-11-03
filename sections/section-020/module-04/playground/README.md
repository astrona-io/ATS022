# Retained Volumes Playground

- **Slug:** ats-022-playground-020-04
- **Type:** Astrona playground, a clean environment with no task and no grading

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`). It has a Retain PersistentVolume `playground-archive` that is already Released, and the dynamic claim `scratch-data` used by the Pod `scratch-writer`.

## Run it

```sh
astrona run -c .
astrona destroy ats-022-playground-020-04
```

Status: UNTESTED. The configuration passes `astrona validate`, but the environment has not been started.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/setup.sh` | Applies the starting objects |
| `manifests/start.yaml` | The starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
