# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab has not been run end to end yet; the commands follow the documented behavior of Kubernetes.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-03/labs/lab-01
```

`astrona submit` right after the start shows the check `nothing-else-changed` failing, because two claims are Pending.

## Step 1: Find the causes

Read the events of both claims and list the classes:

```sh
kubectl -n starfleet describe pvc reports
kubectl -n starfleet describe pvc telemetry
kubectl get storageclass
```

The claim `reports` names the class `standard-fast`, and the class list has no such class. The claim `telemetry` names `training-offline`, which exists. Its provisioner is `example.com/no-such-provisioner`, and the events on the claim show that it waits for that external provisioner. Check the provisioner name:

```sh
kubectl get storageclass training-offline -o jsonpath='{.provisioner}{"\n"}'
```

## Step 2: Remove the Pods and the claims

The field `storageClassName` of a claim cannot be edited, and the volumes of a Pod cannot be edited. A claim that a Pod uses is protected, so delete the Pods first and then the claims:

```sh
kubectl -n starfleet delete pod reports-writer telemetry-writer
kubectl -n starfleet delete pvc reports telemetry
```

## Step 3: Create them again with a working class

Save this as `workloads-storage.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: reports
  namespace: starfleet
spec:
  storageClassName: standard
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: telemetry
  namespace: starfleet
spec:
  storageClassName: standard
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: reports-writer
  namespace: starfleet
spec:
  containers:
  - name: writer
    image: docker.io/library/busybox:1.37.0
    command: ["sh", "-c", "echo ok > /data/ok.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: reports
---
apiVersion: v1
kind: Pod
metadata:
  name: telemetry-writer
  namespace: starfleet
spec:
  containers:
  - name: writer
    image: docker.io/library/busybox:1.37.0
    command: ["sh", "-c", "echo ok > /data/ok.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: telemetry
```

Apply it and wait for the Pods:

```sh
kubectl apply -f workloads-storage.yaml
kubectl -n starfleet wait --for=condition=Ready pod/reports-writer pod/telemetry-writer --timeout=180s
```

The class `standard` waits for the first consumer, so each claim binds after its Pod is scheduled. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-03/labs/lab-01
```

All four checks pass. Remove the lab with `astrona destroy ats-022-lab-010-03`.

## Common pitfalls

> [!WARNING]
> Do not edit or delete `training-offline`. The task is to repair the claims. Deleting a claim that a Pod still uses leaves it in the phase Terminating, so remove the Pods first.
