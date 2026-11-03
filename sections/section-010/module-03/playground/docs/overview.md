# Overview: Pending Claims (Playground)

This is a playground, not a lab. It starts a cluster in which some claims are Pending on purpose, and waits. There is no task, no `astrona submit` and no pass or fail. Diagnose, repair, break things, run `astrona destroy`, start over.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- The default StorageClass `standard` (`rancher.io/local-path`, `WaitForFirstConsumer`, `Delete`) and a class `training-offline` whose provisioner is `example.com/no-such-provisioner`.

  | Namespace | Object | State |
  | --- | --- | --- |
  | `starfleet` | claim `orphan-data` and Pod `orphan-writer` | The claim names the class `standard-fast`, which does not exist |
  | `starfleet` | claim `offline-data` and Pod `offline-writer` | The class exists, but no controller serves its provisioner |
  | `starfleet` | claim `wait-data` | Class `standard`, no Pod uses it yet |

## Practice tasks

- Read the events of each claim with `kubectl describe pvc` and name the component that wrote them.
- Create a Pod that mounts `wait-data` and watch the claim bind.
- Try to patch `storageClassName` on `orphan-data`, then repair it in both ways: create the missing class, or recreate the claim with `standard`.
- Read the logs of the local-path provisioner in the namespace `local-path-storage` while a claim binds.
- Add a `nodeSelector` that no node matches to a new Pod and read its `FailedScheduling` event.
