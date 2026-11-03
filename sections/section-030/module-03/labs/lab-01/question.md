# Question

Solve this question on: `terminal`

The `probe` crew in `starfleet` needs two volumes from the static PersistentVolumes that the administrator prepared: `crate-a`, `crate-b` and `vault-1`. All three use the class name `manual`. Do not edit or delete any volume.

1. Create a claim `ledger` in `starfleet` that requests `100Mi` with the access mode `ReadWriteOnce` from the class `manual`. It must bind only to a volume that has the label `tier=fast`. Choose the volume with a label selector. Do not name the volume with `volumeName`.

2. The claim `manifest` in `starfleet` has been Pending since the start. The crew needs at least `1Gi` for it. Make it bind to the volume `vault-1`.

`kubectl` already points at the cluster as the cluster administrator.
