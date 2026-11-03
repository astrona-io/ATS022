---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Configure StorageClass Fields And The Default Class

A StorageClass is a cluster-wide object that tells Kubernetes how to create storage on demand. Its fields decide who creates the volume, what happens to the volume when the claim is deleted, when the volume is created and whether the volume can grow. A wrong value in one of these fields is stored in every volume the class creates afterwards, and some fields cannot be edited once the class exists.

This module covers every field of a StorageClass that the CKA exam expects an administrator to set, and how Kubernetes chooses a class for a claim that does not name one.

## Learning goals

- Write a StorageClass with `provisioner`, `reclaimPolicy`, `volumeBindingMode` and `allowVolumeExpansion`.
- Name the fields of a StorageClass that the API server will not let you change after creation.
- Explain how `parameters`, `mountOptions` and `allowedTopologies` are used.
- Mark and unmark the default StorageClass with its annotation.
- Predict which class a PersistentVolumeClaim gets when `storageClassName` is omitted, set to an empty string, or set to a name.

## Before you start

You need to know what a PersistentVolumeClaim (PVC) and a PersistentVolume (PV) are, and basic `kubectl get`, `kubectl apply` and `kubectl describe`.

The playground is a single-node kind cluster. It has the default StorageClass `standard`, served by the Rancher local-path provisioner, and a second class named `training-fast`.

## Reading order

1. StorageClass Fields And What They Control
2. The Default StorageClass And Claim Class Selection
3. Summary

Start the playground now and keep it open while you read:

<!-- astrona:playground -->
