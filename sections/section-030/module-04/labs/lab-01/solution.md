# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-04/labs/lab-01
```

## Step 1: Create the StatefulSet

Save this as `statefulset-crew-log.yaml`:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: crew-log
  namespace: starfleet
spec:
  serviceName: crew-log
  replicas: 2
  selector:
    matchLabels:
      app: crew-log
  template:
    metadata:
      labels:
        app: crew-log
    spec:
      containers:
      - name: writer
        image: docker.io/library/busybox:1.37.0
        command:
        - sh
        - -c
        - hostname > /data/owner; sleep 36000
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
      - ReadWriteOnce
      storageClassName: standard
      resources:
        requests:
          storage: 50Mi
```

Apply it:

```sh
kubectl apply -f statefulset-crew-log.yaml
```

Then check the Pods and the claims:

```sh
kubectl -n starfleet rollout status statefulset/crew-log --timeout=240s
kubectl -n starfleet get pvc
```

The claim list contains `data-crew-log-0` and `data-crew-log-1`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-04/labs/lab-01 --keep
```

The checks `statefulset-ready`, `claims-per-replica` and `per-pod-data` now pass.

## Step 2: Find the Pod that holds old-claim

Read the field `Used By`:

```sh
kubectl -n starfleet describe pvc old-claim
```

The Pod `holder` is listed. The claim is Terminating because the finalizer `kubernetes.io/pvc-protection` waits for that Pod.

## Step 3: Stop the Pod

Delete the Pod, not the finalizer:

```sh
kubectl -n starfleet delete pod holder
```

Then check the claim:

```sh
kubectl -n starfleet get pvc old-claim
```

The command returns a `NotFound` error. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-04/labs/lab-01 --keep
```

All four checks pass. When you are done, remove the lab:

```sh
astrona destroy ats-022-lab-030-04
```
