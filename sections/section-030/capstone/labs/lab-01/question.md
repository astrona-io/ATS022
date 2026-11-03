# Question

Solve this question on: `terminal`

This is the Section 030 capstone: one integrated task about persistent volumes and claims, with no step-by-step guidance.

The `scout` team in `starfleet` is taking over the storage of the `probe` service. The administrator prepared the static PersistentVolumes `archive-a` (label `tier=cold`) and `archive-b` (label `tier=hot`), both of class `manual`. Do not edit or delete them. Finish these four jobs:

1. Create a claim `vault` for `300Mi` with `ReadWriteOnce` and the class `manual`. It must bind to the volume labelled `tier=hot`. Choose that volume with a label selector and not by name.

2. Create a StatefulSet `relay` with the headless Service `relay` that already exists. It has 2 replicas of a `busybox:1.37.0` container that sleeps. Each replica needs its own `50Mi` `ReadWriteOnce` claim of the class `standard` from a `volumeClaimTemplates` entry named `store`.

3. The Deployment `telemetry-writer` keeps its data on the claim `telemetry` (100Mi, class `training-grow`). The data must stay. Raise the claim to `250Mi` without creating a new claim.

4. The claim `retired-data` was deleted weeks ago, but it still exists. Make it go away without changing its finalizers.

The cluster uses the `rancher.io/local-path` provisioner, which does not resize volumes. The grader reads the request in the claim `spec`, not `status.capacity`.

`kubectl` already points at the cluster as the cluster administrator.
