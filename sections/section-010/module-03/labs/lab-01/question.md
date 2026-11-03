# Question

Solve this question on: `terminal`

The `reports-writer` and `telemetry-writer` Pods in `starfleet` have been stuck since the namespace was created. Each Pod mounts a PersistentVolumeClaim and writes `/data/ok.txt` when it starts. Both claims are Pending, for different reasons.

1. Find out why the claims `reports` and `telemetry` are Pending.

2. Repair both claims so that they are Bound to volumes created by the working provisioner `rancher.io/local-path`. Keep the claim names, the size `64Mi` and the access mode `ReadWriteOnce`.

3. `reports-writer` and `telemetry-writer` must run with the same names, each mounting its own claim at `/data`, and each must have written a non-empty `/data/ok.txt`.

4. Do not delete the StorageClass `training-offline` and do not edit it. No claim in `starfleet` may stay Pending.

`kubectl` already points at the cluster as the cluster administrator.
