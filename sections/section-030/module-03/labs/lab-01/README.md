---
estimated_duration: 20m
---

# Lab: Control Which Volume A Claim Binds

**Status: UNTESTED.** Static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been run.

Graded lab. Three static volumes exist, and one claim is Pending. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-03/labs/lab-01
astrona destroy ats-022-lab-030-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-ledger-bound-to-fast-volume.sh` | `ledger` is Bound to a volume with `tier=fast` |
| `validate-ledger-uses-selector.sh` | `ledger` has a selector on `tier=fast` and no `volumeName` in its applied configuration |
| `validate-ledger-request.sh` | `ledger` asks for 100Mi `ReadWriteOnce` from `manual` |
| `validate-manifest-bound-to-vault.sh` | `manifest` is Bound to `vault-1` and requests at least 1Gi |
| `validate-volumes-unchanged.sh` | `crate-a`, `crate-b` and `vault-1` keep size, class, mode and labels |
