# Ephemeral And Projected Volume Types Playground

- **Slug:** ats-022-playground-020-02
- **Type:** Astrona playground, a clean environment with no task and no grading

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`). It has the namespace `starfleet` with the ConfigMap `scout-settings`, the Secret `scout-token` and an idle Pod `shuttle`.

## Run it

```sh
astrona run -c .
astrona destroy ats-022-playground-020-02
```

Status: UNTESTED. The configuration passes `astrona validate`, but the environment has not been started.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/setup.sh` | Applies the starting objects |
| `manifests/start.yaml` | The starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
