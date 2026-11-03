# Question

Solve this question on: `terminal`

The `shuttle` feed in `starfleet` has exactly one writer and any number of readers. The cluster has two static PersistentVolumes with no StorageClass: `training-single` (`ReadWriteOncePod`) and `training-readonly` (`ReadOnlyMany`).

1. Create the claim `feed-single` in `starfleet`. It requests `64Mi` and only the access mode `ReadWriteOncePod`, uses `storageClassName: ""`, and binds to `training-single`.
2. Create the Pod `feed-writer` that mounts `feed-single` at `/data` and is Ready. It uses the image `docker.io/library/busybox:1.37.0` and the command `sleep 3600`.
3. Create the Pod `feed-second` with the same image and command. It also mounts `feed-single` at `/data`. It must exist and must stay Pending, unscheduled, while `feed-writer` runs.
4. Create the claim `feed-shared` in `starfleet`: `64Mi`, `ReadOnlyMany`, `storageClassName: ""`, bound to `training-readonly`. Create the Pod `feed-reader` (same image and command) that mounts it at `/data`. The Pod must set `readOnly: true` on the claim reference in its volume, be Ready, and fail every write to `/data`.

`kubectl` already points at the cluster as the cluster administrator.
