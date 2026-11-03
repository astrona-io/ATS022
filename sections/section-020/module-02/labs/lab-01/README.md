---
estimated_duration: 25m
---

# Lab: Combine Memory-Backed And Projected Volumes

Status: UNTESTED. Static checks only (`astrona validate`, `bash -n`). Graded lab for the volume types module. The cluster starts with a ConfigMap and a Secret. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-022-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-pod-running.sh` | `scout-relay` is Ready with containers `writer` and `reader` |
| `validate-shared-emptydir.sh` | A memory-backed `emptyDir` of `64Mi`, mounted by both containers, shares files |
| `validate-projected-settings.sh` | A projected volume combines both sources, is read-only in `reader`, token mode is `400` |
| `validate-settings-read-only.sh` | `reader` cannot write to the projected directory |
