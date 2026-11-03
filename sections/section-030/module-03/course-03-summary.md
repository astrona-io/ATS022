---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Summary

The PersistentVolume controller binds a claim to a volume only when the class name is equal, the access modes of the claim are a subset of those of the volume, the volume mode is equal and the capacity is at least the request. When a selector exists, the volume labels must match it too. Among the volumes that match, the controller chooses the smallest one, and the claim gets that whole volume.

A label selector steers the choice but does not reserve a volume. The field `volumeName` on a claim names a volume. The field `claimRef` on a volume names the only claim that may use it. A claim with a selector is never dynamically provisioned. The fields `storageClassName`, `accessModes` and `volumeName` of a claim cannot be changed, so a wrong claim is deleted and created again.

A volume moves through the phases `Available`, `Bound`, `Released` and `Failed`. A `Released` volume still has the old `claimRef` and stays out of use until an administrator clears it. The field `nodeAffinity` limits the nodes that can use a volume, and it is required for `local` volumes. The field `mountOptions` passes unvalidated options to the mount of volume types that mount through the node.

When a claim is Pending, its events and a field-by-field comparison with the available volumes show the mismatch.

- Class, modes, size and selector must all match for binding.
- The smallest matching volume wins, and equal volumes give an unpredictable choice.
- `claimRef` reserves a volume, and a selector does not.

<!-- astrona:playground:destroy -->
