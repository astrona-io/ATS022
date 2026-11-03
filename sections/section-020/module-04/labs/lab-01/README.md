---
estimated_duration: 25m
---

# Lab: Reuse A Released Volume And Keep A Dynamic Volume

Status: UNTESTED. Static checks only (`astrona validate`, `bash -n`). The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-04/labs/lab-01
astrona destroy ats-022-lab-020-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-archive-rebound.sh` | `training-archive` and `archive-restore` are Bound to each other |
| `validate-archive-still-retained.sh` | The volume keeps `Retain` and its original host path |
| `validate-scratch-volume-survives.sh` | The volume behind `scratch-data` exists, is `Retain` and `Released` with the old `claimRef` |
| `validate-scratch-objects-removed.sh` | `scratch-data` and `scratch-writer` are gone |

The bootstrap records the dynamic volume's name in the ConfigMap `lab-state`, because the claim no longer names it after deletion.
