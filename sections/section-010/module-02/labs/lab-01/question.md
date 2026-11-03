# Question

Solve this question on: `terminal`

The `shuttle` crew in `starfleet` needs a place to keep logs that survives the deletion of their claim. The platform team wants new claims that name no class to land on that storage by default.

1. Create a StorageClass `training-retain` with the provisioner `rancher.io/local-path`, the reclaim policy `Retain`, the binding mode `WaitForFirstConsumer` and volume expansion allowed.

2. Make `training-retain` the only default StorageClass. Do not delete the class `standard`.

3. In `starfleet`, create a PersistentVolumeClaim `logs-data` that requests `64Mi` with access mode `ReadWriteOnce` and does not set `storageClassName`.

4. In `starfleet`, create a Pod `logs-writer` with the image `docker.io/library/busybox:1.37.0` that mounts `logs-data` at `/data` and writes a non-empty file `/data/written.txt` when it starts. The claim must be bound and the Pod must be running. The PersistentVolume behind the claim must have the reclaim policy `Retain`.

`kubectl` already points at the cluster as the cluster administrator.
