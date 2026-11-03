# Question

Solve this question on: `terminal`

This is the Section 010 capstone: one integrated storage task, no step-by-step guidance.

The `probe` Deployment in `starfleet` stores its boot time in `/data/boot.txt` on the claim `probe-data`. It has never started. The platform team wants all new probe and shuttle storage on a class that keeps the data when a claim is deleted, and that class must be what a claim gets when it names no class.

1. The `probe` Deployment must be available. Keep the claim name `probe-data`, the size `64Mi` and the Deployment object itself: do not delete and recreate the Deployment. The claim must be served by a StorageClass named `fast-retain`.

2. `fast-retain` must use the provisioner `rancher.io/local-path`, the reclaim policy `Retain`, the binding mode `WaitForFirstConsumer` and allow volume expansion.

3. `fast-retain` must be the only default StorageClass. Do not delete the class `standard`.

4. In `starfleet`, create a claim `shuttle-data` of `32Mi` with access mode `ReadWriteOnce` that does not set `storageClassName`, and a Pod `shuttle` (image `docker.io/library/busybox:1.37.0`) that mounts it at `/data` and writes a non-empty file `/data/log.txt` when it starts.

5. The PersistentVolumes behind `probe-data` and `shuttle-data` must both keep the reclaim policy `Retain`.

`kubectl` already points at the cluster as the cluster administrator.
