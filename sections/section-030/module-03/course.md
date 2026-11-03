---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Control Which Volume A Claim Binds

When an administrator creates PersistentVolumes by hand, a claim does not choose its volume by name unless it says so. A control loop in the cluster picks one from the volumes that match. If you do not know the matching rules, a claim binds to the wrong volume or stays Pending without a clear reason. This module explains the rules and the tools that steer them.

## Learning goals

- Name the fields that a PersistentVolume must satisfy for a claim to bind to it.
- Steer a claim to one volume with a label selector, `volumeName` or `claimRef`.
- Explain how the control loop chooses among several matching volumes.
- Read the phases of a PersistentVolume: `Available`, `Bound`, `Released` and `Failed`.
- Restrict a volume to nodes with `nodeAffinity`, and set `mountOptions`.
- Diagnose a Pending claim that uses static volumes from its events.

## Before you start

You need to know what a PersistentVolume (PV), a PersistentVolumeClaim (PVC) and a StorageClass are, and how `kubectl describe` shows events.

The playground is a single-node kind cluster. It has three static PVs named `crate-a`, `crate-b` and `vault-1`, all with the class name `manual`, and a claim `manifest` in the `starfleet` namespace that stays Pending.

## Reading order

1. How A Claim Finds Its Volume
2. Node Affinity, Mount Options And Pending Claims
3. Summary

Start your playground now and keep it running while you read:

<!-- astrona:playground -->
