---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Summary

A bound claim grows by an edit to `spec.resources.requests.storage`. The API server accepts the edit only when the StorageClass of the claim sets `allowVolumeExpansion: true` and the claim was dynamically provisioned. A claim cannot shrink, and its class cannot change.

After the API server stores the request, other components do the work. For a CSI driver, the `external-resizer` asks the driver to grow the backing volume and the control plane records the new capacity on the PV. For a volume with a file system, the kubelet grows the file system on the node when a Pod mounts the claim read-write. The conditions `Resizing` and `FileSystemResizePending` and the events on the claim show where the work stands.

Two sizes exist. `spec.resources.requests.storage` is what the user asked for. `status.capacity.storage` is what the storage system provides. A resize can be accepted and still not grow, for example when the driver has no resize support, as with the local-path provisioner of a kind cluster. A static volume is not resized by a controller, so an administrator must grow the storage and edit the PV by hand.

- `allowVolumeExpansion` is a mutable StorageClass field and does not change existing volumes.
- A refused edit means the class or the claim type is wrong. An accepted edit without growth means the driver or the node step is missing.
- Compare `spec` with `status` before you decide that a resize worked.

<!-- astrona:playground:destroy -->
