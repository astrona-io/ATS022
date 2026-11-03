# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab has not been run end to end yet; the commands follow the documented behavior of Kubernetes.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Find why probe does not start

```sh
kubectl -n starfleet get pods,pvc
kubectl -n starfleet describe pvc probe-data
kubectl get storageclass
```

The claim `probe-data` names the class `fast-retain`. The class list has no such class, and the events of the claim say that the class was not found. The field `storageClassName` cannot be edited, and the task wants the claim name and the Deployment unchanged. The repair is to create the class the claim names.

## Step 2: Create the class and make it the only default

Save this as `storageclass-fast-retain.yaml`:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-retain
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

Apply it, then remove the default marker from `standard`:

```sh
kubectl apply -f storageclass-fast-retain.yaml
kubectl patch storageclass standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl get storageclass
```

Only `fast-retain` shows `(default)`. The scheduler retries the `probe` Pod. When it picks a node, the provisioner creates the volume with the policy `Retain`. Wait for the Deployment:

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=240s
```

If the claim is still Pending after a few minutes, read its events again. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/capstone/labs/lab-01 --keep
```

The checks `fast-retain-class`, `single-default-class`, `probe-available` and `deployment-kept` pass.

## Step 3: Add the shuttle storage

Do not name a class. Save this as `workload-shuttle.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: shuttle-data
  namespace: starfleet
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: shuttle
  namespace: starfleet
spec:
  containers:
  - name: writer
    image: docker.io/library/busybox:1.37.0
    command: ["sh", "-c", "date > /data/log.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: shuttle-data
```

Apply it and check the stored class and both policies:

```sh
kubectl apply -f workload-shuttle.yaml
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=180s
kubectl -n starfleet get pvc shuttle-data -o jsonpath='{.spec.storageClassName}{"\n"}'
kubectl get pv -o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name,RECLAIM:.spec.persistentVolumeReclaimPolicy
```

The claim has the class `fast-retain`, and both volumes show `Retain`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/capstone/labs/lab-01
```

All six checks pass. Remove the lab with `astrona destroy ats-022-capstone-010`.

## Common pitfalls

> [!WARNING]
> If you create `shuttle-data` before `fast-retain` is the only default, the claim gets another class and cannot be edited. Delete the Pod and the claim and create them again. Do not delete the `probe` Deployment: the grader compares its identity with the one recorded at the start.
