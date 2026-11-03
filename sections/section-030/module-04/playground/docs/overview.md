# Overview: Mount Claims In Workloads And Protect Them (Playground)

This is a playground, not a lab. It starts a cluster with one claim in use, then waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the environment

- A single-node kind cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator. The default StorageClass is `standard` (provisioner `rancher.io/local-path`, binding mode `WaitForFirstConsumer`).
- In `starfleet`: the claim `old-claim` of 50Mi, the Pod `holder` that mounts it at `/data`, and the headless Service `beacon-log`.

## Practice tasks

- Create a StatefulSet `beacon-log` with `serviceName: beacon-log`, two replicas and a `volumeClaimTemplates` entry named `data`. Name the claims it creates.
- Delete the StatefulSet and check which claims remain. Then create it again and check that the Pods use the old claims.
- Add `persistentVolumeClaimRetentionPolicy` with `whenDeleted: Delete` and repeat the deletion.
- Delete `old-claim` and read its status and finalizers. Find the Pod that holds it, and release the claim in the right order.
- Mount a claim with `readOnly: true` and try to write to it.
