# Overview: Retained Volumes

This is a playground, not a lab. It starts a single-node kind cluster and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the environment

| Object | What it is |
| --- | --- |
| PersistentVolume `playground-archive` | 64Mi, `Retain`, hostPath. Its old claim was deleted, so its phase is `Released` |
| PersistentVolumeClaim `scratch-data` | Dynamic claim from the `standard` class in `starfleet` |
| Pod `scratch-writer` | Writes a file to `scratch-data` and keeps running |

`kubectl` already points at the cluster as the cluster administrator.

## Practice ideas

- Read the phase and the `claimRef` of `playground-archive`. Create a claim that names it with `volumeName` and see that it stays Pending.
- Remove `spec.claimRef` with a JSON patch and watch the volume become `Available`, then bind to your claim.
- Find the PersistentVolume behind `scratch-data` and read its reclaim policy.
- Delete `scratch-data` while `scratch-writer` runs and read its `deletionTimestamp` and finalizers. Delete the Pod and watch the claim go away.
- Repeat the delete with the volume patched to `Retain` first, and compare what remains.
