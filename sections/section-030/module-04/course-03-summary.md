---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Summary

A Pod uses a claim through `spec.volumes[].persistentVolumeClaim.claimName` in its own namespace and mounts it with `volumeMounts`. The options `readOnly` and `subPath` limit what a container sees. All replicas of a Deployment name the same claim, so they share one volume, which works with `ReadWriteOnce` only on a single node.

A StatefulSet creates one claim per replica from `volumeClaimTemplates`, named `<template>-<statefulset>-<ordinal>`. The claims are kept when the StatefulSet is scaled down or deleted, and a new StatefulSet with the same name mounts them again. The field `persistentVolumeClaimRetentionPolicy` with `whenDeleted` and `whenScaled` can change this to `Delete`. The default for both is `Retain`.

Storage object in use protection keeps a claim in the API while a Pod uses it. The finalizer `kubernetes.io/pvc-protection` on the claim and `kubernetes.io/pv-protection` on the volume make a delete request leave the object in the status `Terminating` until the use ends. `kubectl describe pvc` shows the Pods that use a claim. Deleting the Pod, or the controller that recreates it, lets the claim go. The reclaim policy of the volume then decides whether the data survives.

- A claim name belongs to one namespace, and a Pod can mount only claims of its own namespace.
- Claims created by a StatefulSet survive its deletion unless the retention policy says otherwise.
- Stop the user of a claim before you remove it. Never patch away a finalizer while a Pod runs.

<!-- astrona:playground:destroy -->
