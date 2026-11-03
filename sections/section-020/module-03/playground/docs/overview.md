# Overview: Access Modes

This is a playground, not a lab. It starts a single-node kind cluster and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the environment

| Object | What it is |
| --- | --- |
| Namespace `starfleet` | Empty namespace for claims and Pods |
| PersistentVolume `playground-single` | 64Mi, `ReadWriteOncePod`, hostPath, no class |
| PersistentVolume `playground-shared` | 64Mi, `ReadOnlyMany`, hostPath, no class |

No claim exists. `kubectl` already points at the cluster as the cluster administrator.

## Practice ideas

- Create a claim with `ReadWriteOncePod` and `storageClassName: ""` and watch it bind to `playground-single`.
- Start one Pod that mounts the claim, then a second Pod that mounts the same claim. Read the second Pod's events with `kubectl describe pod`.
- Delete the first Pod and watch the second Pod.
- Create a claim for `playground-shared`, mount it with `readOnly: true` on the claim reference, and try to write a file from the container.
- Ask for `ReadWriteMany` in a claim and see why it stays Pending against these volumes.
