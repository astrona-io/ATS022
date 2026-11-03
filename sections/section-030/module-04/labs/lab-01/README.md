---
estimated_duration: 20m
---

# Lab: Mount Claims In Workloads And Protect Them

**Status: UNTESTED.** Static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been run.

Graded lab. A claim waits in Terminating because a Pod holds it, and a StatefulSet must be created. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-04/labs/lab-01
astrona destroy ats-022-lab-030-04
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-statefulset-ready.sh` | `crew-log` has 2 ready replicas and `serviceName: crew-log` |
| `validate-claims-per-replica.sh` | The template `data` made Bound 50Mi `ReadWriteOnce` claims of class `standard` for both ordinals |
| `validate-per-pod-data.sh` | Each Pod wrote its own host name to its own claim |
| `validate-old-claim-released.sh` | `old-claim` and the Pod `holder` no longer exist |
