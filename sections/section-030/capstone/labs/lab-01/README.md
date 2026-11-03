---
estimated_duration: 30m
---

# Lab: Persistent Volumes And Claims Capstone

**Status: UNTESTED.** Static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been run.

Capstone for section 030. Four jobs in one cluster: bind a claim to a labelled static volume with a selector, create a StatefulSet with claim templates, grow a claim in place, and release a claim that a Pod holds. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-022-capstone-030
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-vault-bound-to-hot.sh` | `vault` is Bound to `archive-b`, with a `tier: hot` selector, `manual`, `ReadWriteOnce`, 300Mi |
| `validate-relay-claims.sh` | `relay` has 2 ready replicas and Bound 50Mi claims `store-relay-0` and `store-relay-1` |
| `validate-telemetry-grown.sh` | The original `telemetry` claim requests at least 250Mi and `training-grow` allows expansion (never `status.capacity`) |
| `validate-retired-data-released.sh` | `retired-data` and `retired-holder` are gone |
| `validate-volumes-and-workload-unchanged.sh` | `archive-a`, `archive-b` and `telemetry-writer` keep their definition |
