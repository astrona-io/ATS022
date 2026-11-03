# Question

Solve this question on: `terminal`

This is the section capstone: one integrated storage task, no step-by-step guidance.

The `probe` crew in `starfleet` is moving to a new logging setup. Complete all three parts. Every container uses the image `docker.io/library/busybox:1.37.0` and the command `sleep 3600`.

1. Create the Pod `probe-logger` with the containers `collector` and `reporter`. They share scratch space that lives in memory and is limited to `32Mi`. The `reporter` also reads the ConfigMap `probe-settings` and the Secret `probe-token` through one directory that it cannot write to; the token file in that directory is readable by its owner only.
2. The PersistentVolume `training-ledger` (`64Mi`, `Retain`, access mode of one Pod) is Released. Create the claim `ledger-current` in `starfleet` so that it binds to that same volume and only one Pod at a time can use it. Run the Pod `ledger-writer` on it and make it write. Create a second Pod `ledger-extra` on the same claim that must exist but stay unscheduled.
3. The team retires the claim `journal` and the Pod `journal-writer`. Remove both, but the volume behind `journal` must keep its data: it must still exist, with the policy `Retain`, in the phase `Released`. Do not delete the ConfigMap `lab-state`.

`kubectl` already points at the cluster as the cluster administrator.
