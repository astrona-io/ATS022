# Overview: StorageClass Fields And The Default Class (Playground)

This is a playground, not a lab. It starts a cluster and waits. There is no task, no `astrona submit` and no pass or fail. Create classes and claims, break them, run `astrona destroy`, start over.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- The default StorageClass `standard`. Its provisioner is `rancher.io/local-path`, its binding mode is `WaitForFirstConsumer` and its reclaim policy is `Delete`. The local-path provisioner supports file system volumes only.
- A StorageClass `training-fast` with the same provisioner, that is not the default.
- The namespaces `starfleet` and `outpost`, and a `probe` Deployment in `starfleet` that uses no storage.

## Practice tasks

- Create a class with `reclaimPolicy: Retain` and `allowVolumeExpansion: true`, then create a claim and a Pod that uses it. Read the policy on the PV.
- Try to patch `volumeBindingMode` on an existing class and read the error. Then patch `allowVolumeExpansion` on the same class.
- Create a claim without `storageClassName`, a claim with `""` and a claim with `training-fast`. Compare the stored class names.
- Annotate `training-fast` as a second default. Create a claim without a class and read which class it got. Remove the annotation again.
- Delete a StorageClass that has bound claims. Check that the claims and PVs stay and that new claims for that class stay Pending.
