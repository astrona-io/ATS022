# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab has not been run end to end yet; the commands follow the documented behavior of Kubernetes.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-02/labs/lab-01
```

## Step 1: Create the class

The class holds the policy that every new volume copies. Save this as `storageclass-training-retain.yaml`:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: training-retain
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

Apply it:

```sh
kubectl apply -f storageclass-training-retain.yaml
```

The annotation already marks the class as a default, which is part of task 2. The cluster now has two default classes.

## Step 2: Leave one default

Set the annotation on `standard` to `"false"`:

```sh
kubectl patch storageclass standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl get storageclass
```

Only `training-retain` shows `(default)`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-02/labs/lab-01 --keep
```

The checks `training-retain-class` and `single-default-class` pass.

## Step 3: Create the claim and the Pod

Do not name a class in the claim. Save this as `workload-logs.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: logs-data
  namespace: starfleet
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: logs-writer
  namespace: starfleet
spec:
  containers:
  - name: writer
    image: docker.io/library/busybox:1.37.0
    command: ["sh", "-c", "date > /data/written.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: logs-data
```

Apply it and wait for the Pod:

```sh
kubectl apply -f workload-logs.yaml
kubectl -n starfleet wait --for=condition=Ready pod/logs-writer --timeout=180s
```

The claim waits for its first consumer, so it binds only after the Pod is created. Check the stored class and the policy of the volume:

```sh
kubectl -n starfleet get pvc logs-data -o jsonpath='{.spec.storageClassName}{"\n"}'
kubectl get pv -o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name,RECLAIM:.spec.persistentVolumeReclaimPolicy
```

The class is `training-retain` and the policy is `Retain`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-010/module-02/labs/lab-01
```

All five checks pass. Remove the lab with `astrona destroy ats-022-lab-010-02`.

## Common pitfalls

> [!WARNING]
> If you create the claim before `training-retain` is the default, the API server stores `standard` in it, and `storageClassName` cannot be changed afterwards. Delete the Pod and the claim and create them again.
