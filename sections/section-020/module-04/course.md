---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Release And Reuse Retained Volumes

When a claim is deleted, the PersistentVolume behind it must go somewhere. The reclaim policy decides whether the volume and its data are deleted or kept, and a kept volume does not return to service by itself. This module explains what happens to a dynamically provisioned volume when its claim is deleted, how to change the policy while the volume is bound, why a Released volume refuses new claims, and how an administrator makes it bindable again.

## Learning Goals

- State what `Delete` and `Retain` do to the PV and to the backing data when a claim is deleted.
- Patch the reclaim policy of a bound PV before its claim is deleted.
- Explain why a claim cannot be deleted while a Pod uses it.
- Explain the `Released` phase and why a Released PV does not bind.
- Make a Released PV bindable again and bind a new claim to it.

## Before You Start

You need to know what a PersistentVolume (PV), a PersistentVolumeClaim (PVC) and a StorageClass are. The module playground has the Retain PV `playground-archive`, already Released, and the dynamic claim `scratch-data` used by the Pod `scratch-writer`.

## Reading Order

1. Reclaim Policy And Claim Deletion
2. Released Volumes And Rebinding
3. Summary

<!-- astrona:playground -->
