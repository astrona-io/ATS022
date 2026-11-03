---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Summary

Access modes describe how many nodes or Pods may use a volume and whether they may write. The storage driver decides which modes a volume supports, and the PV controller binds a claim only to a volume that lists every mode the claim requests. The volume mode decides the shape of the data: `Filesystem` mounts a directory with `volumeMounts`, and `Block` hands a raw device to the container through `volumeDevices` and `devicePath`.

`ReadWriteOnce` limits a volume to one node, so several Pods on that node may use it. `ReadOnlyMany` and `ReadWriteMany` allow many nodes, read-only or read-write. `ReadWriteOncePod` limits the volume to one Pod in the cluster. The kube-scheduler enforces that with the `VolumeRestrictions` plugin: a second Pod that uses an in-use RWOP claim stays Pending with a `FailedScheduling` event and starts only after the first Pod is gone.

Read-only access is set on a container's mount with `readOnly`, or on the whole Pod's use of the claim with `readOnly` under `persistentVolumeClaim`. The first protects one container, and the second protects the volume for every container in the Pod.

Key facts:

- RWO is per node, RWOP is per Pod.
- A Pod blocked by RWOP is Pending and has no container logs; its events give the reason.
- `storageClassName: ""` keeps a claim from receiving the default class.
- `Block` volumes use `volumeDevices`, not `volumeMounts`.

<!-- astrona:playground:destroy -->
