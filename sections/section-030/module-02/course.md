---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Resize A Persistent Volume Claim

A claim that was too small when it was created does not have to be recreated. Kubernetes can grow the volume behind a claim while the claim stays bound and its data stays in place. This module explains which settings allow it, which components do the work, and why a resize request is sometimes refused or accepted without any visible growth.

## Learning goals

- Explain what `allowVolumeExpansion` on a StorageClass controls.
- Raise the size of a bound claim by editing `spec.resources.requests.storage`.
- Name the components that grow the volume and the file system.
- Read the claim conditions and events that show a resize in progress.
- Diagnose a refused resize: class without expansion, static volume, driver without resize support.
- Tell the requested size in `spec` from the real size in `status.capacity`.

## Before you start

You need to know what a PersistentVolume (PV), a PersistentVolumeClaim (PVC) and a StorageClass are, and how to read an object with `kubectl get -o yaml`.

The playground is a single-node kind cluster. It has two StorageClasses, `training-grow` and `training-expand`, two 100Mi claims named `data` and `logs` in the `starfleet` namespace, and a Deployment `data-writer` that mounts both claims.

## Reading order

1. Grow A Claim Through Its StorageClass
2. When A Resize Is Refused Or Does Not Grow
3. Summary

Start your playground now and keep it running while you read:

<!-- astrona:playground -->
