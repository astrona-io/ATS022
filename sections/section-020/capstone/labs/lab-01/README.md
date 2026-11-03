---
estimated_duration: 40m
---

# Capstone: Volume Types, Access Modes And Reclaim Handling

Status: UNTESTED. Static checks only (`astrona validate`, `bash -n`). Open risk: Kubernetes documents `ReadWriteOncePod` for CSI volumes; this capstone uses a hostPath volume and relies on the scheduler's claim check. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-022-capstone-020
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-logger-volumes.sh` | `probe-logger` shares a 32Mi memory `emptyDir`; `reporter` reads a read-only projected volume with the token at mode 400 |
| `validate-ledger-claim.sh` | `ledger-current` is `ReadWriteOncePod`, bound to `training-ledger`; `ledger-writer` writes to it |
| `validate-ledger-extra-pending.sh` | `ledger-extra` uses the claim and stays Pending, unscheduled |
| `validate-journal-volume-survives.sh` | The volume behind `journal` is `Retain` and `Released` |
| `validate-journal-objects-removed.sh` | `journal` and `journal-writer` are gone |
