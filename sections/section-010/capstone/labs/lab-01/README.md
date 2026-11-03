---
estimated_duration: 30m
---

# Capstone: StorageClasses And Dynamic Provisioning

Status: UNTESTED (static checks only). Graded integration lab for the whole section. A claim names a StorageClass that does not exist and blocks a Deployment. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-022-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-fast-retain-class.sh` | Provisioner, `Retain`, `WaitForFirstConsumer`, `allowVolumeExpansion: true` |
| `validate-single-default-class.sh` | `fast-retain` is the only default class |
| `validate-probe-available.sh` | `probe` is available, `probe-data` is Bound on `fast-retain`, `/data/boot.txt` is not empty |
| `validate-shuttle-uses-default.sh` | `shuttle-data` got `fast-retain` without naming it, `shuttle` wrote `/data/log.txt` |
| `validate-volumes-retained.sh` | Both PVs have `Retain` |
| `validate-deployment-kept.sh` | The `probe` Deployment UID equals the UID saved in `kube-system/capstone-baseline` |
