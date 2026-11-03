---
estimated_duration: 15m
---

# Lab: Resize A Persistent Volume Claim

**Status: UNTESTED.** Static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been run.

Graded lab. The cluster starts with a class that does not allow expansion and a bound 100Mi claim. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-022-lab-030-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-class-allows-expansion.sh` | `training-grow` has `allowVolumeExpansion: true` and its provisioner is unchanged |
| `validate-claim-requests-300mi.sh` | `spec.resources.requests.storage` of `data` is at least 300Mi (never `status.capacity`) |
| `validate-claim-not-recreated.sh` | `data` has the original UID, is Bound and keeps its class |
| `validate-writer-running.sh` | `data-writer` is ready and still mounts `data` |
