---
estimated_duration: 25m
---

# Lab: Create A Retaining Default StorageClass

Status: UNTESTED (static checks only). Graded lab for the StorageClass fields module. The cluster starts with the kind default class `standard` and a decoy class. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-022-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-training-retain-class.sh` | Provisioner, `Retain`, `WaitForFirstConsumer` and `allowVolumeExpansion: true` |
| `validate-single-default-class.sh` | `training-retain` is the only class with the default annotation |
| `validate-logs-claim-uses-default.sh` | `logs-data` is Bound, 64Mi, class `training-retain` |
| `validate-logs-writer-wrote.sh` | `logs-writer` runs, uses `logs-data`, `/data/written.txt` is not empty |
| `validate-volume-retained.sh` | The PV of `logs-data` has `Retain` |
