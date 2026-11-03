---
estimated_duration: 25m
---

# Lab: Repair Pending Claims

Status: UNTESTED (static checks only). Graded lab for the Pending claims module. The cluster starts with two claims in `starfleet` that are Pending for different reasons. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-022-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-reports-claim-bound.sh` | `reports` is Bound, 64Mi, in a class served by `rancher.io/local-path` |
| `validate-telemetry-claim-bound.sh` | The same for `telemetry` |
| `validate-writers-running.sh` | Both Pods run, use their own claim and wrote `/data/ok.txt` |
| `validate-nothing-else-changed.sh` | `training-offline` is unchanged and no claim is Pending |
