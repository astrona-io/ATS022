# Overview: Resize A Persistent Volume Claim (Playground)

This is a playground, not a lab. It starts a cluster with two StorageClasses and two claims, then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, run `astrona destroy`, and start again.

## What is in the environment

- A single-node kind cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- Two StorageClasses with the provisioner `rancher.io/local-path`:

  | Class | `allowVolumeExpansion` |
  | --- | --- |
  | `training-grow` | not set |
  | `training-expand` | `true` |

- Two claims of 100Mi in `starfleet`: `data` (class `training-grow`) and `logs` (class `training-expand`).
- The Deployment `data-writer` in `starfleet`, which mounts `data` at `/data` and `logs` at `/logs`. The claims bind when its Pod is scheduled, because both classes use `WaitForFirstConsumer`.

The local-path provisioner is not a CSI driver with a resizer, so `status.capacity` does not prove growth here. Read `spec.resources.requests.storage` to see what the API server accepted.

## Practice tasks

- Raise `logs` to 200Mi and read the claim conditions and events.
- Try to raise `data` to 300Mi, read the error, fix the class and repeat the edit.
- Try to lower `logs` to 50Mi and read the error.
- Find which PV each claim is bound to and compare `spec.capacity` of the PV with the claim request.
- Create a new class with the same provisioner and `allowVolumeExpansion: true`, and try to change `storageClassName` of an existing claim to it.
