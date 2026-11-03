# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab is UNTESTED: the steps follow the reference solution but were not run.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/capstone/labs/lab-01
```

## Step 1: The logger Pod

A memory-backed `emptyDir` with `sizeLimit` is the shared scratch space. A `projected` volume combines the ConfigMap and the Secret, and the item `mode: 0400` sets the token file permission. The `reporter` mounts the projected volume with `readOnly: true`.

Save this as `pod-probe-logger.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probe-logger
  namespace: starfleet
spec:
  containers:
    - name: collector
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: spool
          mountPath: /spool
    - name: reporter
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: spool
          mountPath: /spool
        - name: settings
          mountPath: /etc/probe
          readOnly: true
  volumes:
    - name: spool
      emptyDir:
        medium: Memory
        sizeLimit: 32Mi
    - name: settings
      projected:
        sources:
          - configMap:
              name: probe-settings
          - secret:
              name: probe-token
              items:
                - key: token
                  path: token
                  mode: 0400
```

Apply it:

```sh
kubectl apply -f pod-probe-logger.yaml
kubectl -n starfleet wait --for=condition=Ready pod/probe-logger --timeout=120s
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/capstone/labs/lab-01 --keep
```

## Step 2: Reuse the Released volume with a single-Pod claim

The Released volume keeps a `claimRef` that names the deleted claim. Remove it:

```sh
kubectl patch pv training-ledger --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
```

Save this as `ledger.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ledger-current
  namespace: starfleet
spec:
  accessModes:
    - ReadWriteOncePod
  storageClassName: ""
  volumeName: training-ledger
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: ledger-writer
  namespace: starfleet
spec:
  containers:
    - name: writer
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: ledger
          mountPath: /ledger
  volumes:
    - name: ledger
      persistentVolumeClaim:
        claimName: ledger-current
```

Apply it and wait for the writer:

```sh
kubectl apply -f ledger.yaml
kubectl -n starfleet wait --for=condition=Ready pod/ledger-writer --timeout=120s
```

Save this as `ledger-extra.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ledger-extra
  namespace: starfleet
spec:
  containers:
    - name: writer
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: ledger
          mountPath: /ledger
  volumes:
    - name: ledger
      persistentVolumeClaim:
        claimName: ledger-current
```

Apply it and read the scheduling condition:

```sh
kubectl apply -f ledger-extra.yaml
kubectl -n starfleet get pod ledger-extra -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].status}{"\n"}'
```

The condition is `False`. Grade again with the same `astrona submit` command.

## Step 3: Retire the journal without losing its volume

Read the volume name from the claim and patch the volume to `Retain` first:

```sh
kubectl -n starfleet get pvc journal -o jsonpath='{.spec.volumeName}{"\n"}'
kubectl patch pv <PV> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
```

Replace `<PV>` with the name from the first command. Delete the Pod and then the claim:

```sh
kubectl -n starfleet delete pod journal-writer
kubectl -n starfleet delete pvc journal
```

Grade the final state with the same `astrona submit` command. If the claim was deleted before the patch, the volume is gone and the lab must be restarted.

After you finish, remove the lab with `astrona destroy ats-022-capstone-020`.
