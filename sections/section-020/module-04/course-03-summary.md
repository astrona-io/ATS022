---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Summary

The reclaim policy is a field of the PersistentVolume. A dynamic provisioner copies it from the StorageClass `reclaimPolicy`, which defaults to `Delete`, and a hand-written PV defaults to `Retain`. With `Delete`, deleting the claim deletes the PV and the backing storage. With `Retain`, deleting the claim leaves the PV and its data and sets the PV phase to `Released`.

The policy of an existing PV can be patched with `kubectl patch`, and the change must happen before the claim is deleted. Editing the StorageClass only affects volumes created later. A claim used by a Pod is protected by the finalizer `kubernetes.io/pvc-protection`, so its deletion waits until the Pod is gone, and a bound PV is protected by `kubernetes.io/pv-protection`.

A Released PV keeps its `claimRef`, so it does not bind to a new claim, even one that names it with `volumeName`. The administrator removes `spec.claimRef`, or its `uid` and `resourceVersion` to reserve the volume for one claim name, or recreates the PV object. The PV then becomes `Available` and binds. The data of the previous owner is still on it, so reuse requires a decision about that data.

Key facts:

- The policy lives on the PV, not on the claim.
- Patch to `Retain` before deleting the claim.
- Delete the Pod before the claim, or the claim waits in `Terminating`.
- A Released PV needs its `claimRef` cleared before it binds again.

<!-- astrona:playground:destroy -->
