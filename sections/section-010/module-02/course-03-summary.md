---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Summary

A StorageClass is a cluster-scoped object that holds the settings used when a volume is created. The provisioner field names the controller that creates volumes, parameters are passed to it unread, and the reclaim policy and mount options are copied into each PersistentVolume at creation. Changing the class later does not change volumes that already exist.

The binding mode decides when a volume is created. With Immediate the volume appears when the claim is created. With WaitForFirstConsumer the claim stays Pending until a Pod uses it, so a Pending claim with no Pod is expected. Allowing expansion lets a user raise the requested size of a bound claim, never lower it. The provisioner, parameters, reclaim policy and binding mode cannot be edited on an existing class; the class must be deleted and created again.

A claim picks its class from storageClassName. A name selects that class, an absent field selects the default class, and an empty string selects no class, which leaves the claim to match a manually created volume. The default class is the one with the annotation storageclass.kubernetes.io/is-default-class set to "true". If several carry it, the newest is used, and the choice is written into the claim at creation time and never moves afterwards.

Key facts:

- The default reclaim policy of a class is Delete, the default binding mode is Immediate.
- The API server rejects edits to provisioner, parameters, reclaimPolicy and volumeBindingMode.
- Keep one default class, and move the default by changing annotations.

<!-- astrona:playground:destroy -->
