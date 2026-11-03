# Question

Solve this question on: `terminal`

The `outpost` team returns to the `archive` data that the `probe` kept, and the `scout` team retires its scratch space in `starfleet`. Neither volume may lose data.

1. The PersistentVolume `training-archive` has the reclaim policy `Retain` and the phase `Released`, because its claim was deleted. Create the claim `archive-restore` in `starfleet` (`64Mi`, `ReadWriteOnce`, `storageClassName: ""`) so that it binds to `training-archive`. Keep the same PV object and its `Retain` policy.
2. The claim `scratch-data` in `starfleet` is dynamically provisioned from the `standard` class and used by the Pod `scratch-writer`. Remove the Pod and the claim, but the PersistentVolume behind `scratch-data` must survive, stay `Retain` and end in the phase `Released`. Do not delete the ConfigMap `lab-state`.

`kubectl` already points at the cluster as the cluster administrator.
