---
estimated_duration: 25m
---

# Lab: Enforce A Single-Pod Claim And A Read-Only Mount

Status: UNTESTED. Static checks only (`astrona validate`, `bash -n`). Open risk: Kubernetes documents `ReadWriteOncePod` for CSI volumes; this lab uses hostPath volumes and relies on the scheduler's claim check. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-022-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-single-claim-bound.sh` | `feed-single` asks only for `ReadWriteOncePod` and is bound to `training-single` |
| `validate-writer-runs.sh` | `feed-writer` uses `feed-single`, is Ready and writes to `/data` |
| `validate-second-pod-pending.sh` | `feed-second` uses `feed-single`, is Pending, `PodScheduled` is `False`, no node |
| `validate-reader-read-only.sh` | `feed-shared` is `ReadOnlyMany` and bound; `feed-reader` sets `readOnly: true` and cannot write |
