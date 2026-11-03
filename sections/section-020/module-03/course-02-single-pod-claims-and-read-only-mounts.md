---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Single-Pod Claims And Read-Only Mounts

A team that runs a single writer, such as a leader process or a job that must not run twice, needs a guarantee that two Pods never write to the same data. `ReadWriteOnce` does not give that guarantee, because it limits nodes and not Pods. This part shows what `ReadWriteOncePod` does to a second Pod, and how to give a different Pod read-only access to a volume.

## A second Pod on a ReadWriteOncePod claim

Assume the claim `single-writer` is bound to a volume that lists `ReadWriteOncePod`. Start the first Pod, which mounts the claim at `/data`.

Save this as `pod-feed-writer.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: feed-writer
  namespace: starfleet
spec:
  containers:
    - name: writer
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: single-writer
```

<!-- astrona:playground:renew -->

Apply it:

```sh
kubectl apply -f pod-feed-writer.yaml
```

Then wait for it and write a file:

```sh
kubectl -n starfleet wait --for=condition=Ready pod/feed-writer --timeout=120s
kubectl -n starfleet exec feed-writer -- sh -c 'echo first > /data/owner && cat /data/owner'
```

Now create a second Pod that names the same claim. Save this as `pod-feed-second.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: feed-second
  namespace: starfleet
spec:
  containers:
    - name: writer
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: single-writer
```

Apply it:

```sh
kubectl apply -f pod-feed-second.yaml
```

Then read its phase and conditions:

```sh
kubectl -n starfleet get pod feed-second
kubectl -n starfleet get pod feed-second -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].status}{"\n"}'
```

The Pod stays in the `Pending` phase, and the `PodScheduled` condition is `False`. The API server accepted the Pod object, so `kubectl apply` succeeds. The kube-scheduler refuses to place it. Run `kubectl -n starfleet describe pod feed-second` and read the `Events` section: a `FailedScheduling` event from `default-scheduler` names the reason, and the reason mentions that the claim is already in use by another Pod. Read the event text on your cluster rather than relying on a remembered message.

The scheduler checks again when cluster state changes. Delete the first Pod:

```sh
kubectl -n starfleet delete pod feed-writer
```

After the first Pod is gone, the scheduler can place `feed-second`, and it becomes Running. The claim and the data stay, because they belong to the claim and not to the Pod. This is the guarantee of `ReadWriteOncePod`: at no time do two Pods use the claim.

## Read-only access

Two different fields make a mount read-only, and they work at different levels.

The field `readOnly` on a `volumeMounts` entry makes that one container's mount read-only. Other containers of the same Pod can still write.

The field `readOnly` under `persistentVolumeClaim` in `spec.volumes` makes the volume read-only for every container of the Pod that uses it, and tells the volume plugin to attach the volume read-only where it can.

```yaml
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: shared-feed
        readOnly: true
```

A volume with `ReadOnlyMany` can be mounted by Pods on many nodes. Kubernetes does not turn an RWO volume into a read-only volume by itself: a second Pod that mounts an RWO claim on the same node is allowed, and `readOnly` on its mount is what keeps it from writing. For a ROX volume, a Pod that mounts the claim read-write gets a mount that the volume refuses to write to, or fails to start, depending on the driver.

Try the read-only claim reference with the second static volume. Save this as `pvc-shared-feed.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: shared-feed
  namespace: starfleet
spec:
  accessModes:
    - ReadOnlyMany
  storageClassName: ""
  resources:
    requests:
      storage: 64Mi
```

Apply it:

```sh
kubectl apply -f pvc-shared-feed.yaml
```

Create a Pod that mounts it with `readOnly: true` on the claim reference, as in the snippet above, and run `kubectl exec` with `sh -c 'echo x > /data/new'`. The write fails because the mount is read-only.

You now know that RWOP is enforced by the scheduler, that a blocked Pod stays Pending without an error from the API, and that read-only is set on the mount or on the claim reference. Which volume survives when the claim itself is deleted depends on the reclaim policy.

## Common pitfalls

> [!WARNING]
> A Pod blocked by `ReadWriteOncePod` is Pending, not failed, and its container never starts, so there is no log to read: read the Pod events. Setting `readOnly` on one container's mount does not protect other containers of the same Pod. Deleting the first Pod frees the claim and lets the second Pod start, so a rolling update of a Deployment that uses a RWOP claim can stall unless the old Pod is removed first.
