# Overview: Control Which Volume A Claim Binds (Playground)

This is a playground, not a lab. It starts a cluster with static volumes and one Pending claim, then waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the environment

- A single-node kind cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- Three PersistentVolumes with `storageClassName: manual`, access mode `ReadWriteOnce` and reclaim policy `Retain`. They use `hostPath`, which is only suitable for a disposable single-node cluster:

  | PV | Size | Label |
  | --- | --- | --- |
  | `crate-a` | 200Mi | `tier=slow` |
  | `crate-b` | 200Mi | `tier=fast` |
  | `vault-1` | 2Gi | none |

- The claim `manifest` in `starfleet`: class `archive`, access mode `ReadWriteMany`, 5Gi. No volume matches it, so it stays Pending.
- No StorageClass object named `manual` or `archive` exists. For static binding the class name only has to be equal on the volume and the claim.

## Practice tasks

- Describe `manifest` and read its events. Name each field that does not match.
- Create a claim of 100Mi with the class `manual` and no selector. Predict which volume it binds, then check.
- Create a claim with `selector.matchLabels` of `tier: fast` and compare.
- Create a claim with `matchExpressions` that uses `NotIn` for the label `tier`.
- Pre-bind a volume with `claimRef` and show that another claim cannot take it.
- Create a PV with `nodeAffinity` for the hostname of the node, and bind a claim to it.
