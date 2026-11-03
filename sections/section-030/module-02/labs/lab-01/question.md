# Question

Solve this question on: `terminal`

The `data-writer` Deployment of the `probe` crew in `starfleet` is filling its 100Mi claim `data`, and the crew must keep every file on it. Grow the claim without losing the data and without recreating it.

1. The claim `data` belongs to the StorageClass `training-grow`. The class does not allow expansion yet. Allow it on the class itself. Do not create a new class.

2. Raise the request of the claim `data` in `starfleet` to `300Mi`. Do not delete the claim and do not change the Deployment.

The cluster uses the `rancher.io/local-path` provisioner, which does not resize volumes. The grader reads the request in the claim `spec`, not `status.capacity`.

`kubectl` already points at the cluster as the cluster administrator.
