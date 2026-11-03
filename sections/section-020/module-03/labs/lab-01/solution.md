# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab is UNTESTED: the steps follow the reference solution but were not run.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-03/labs/lab-01
```

## Step 1: Claim the single-Pod volume and start the writer

Save this as `feed-single.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: feed-single
  namespace: starfleet
spec:
  accessModes:
    - ReadWriteOncePod
  storageClassName: ""
  volumeName: training-single
  resources:
    requests:
      storage: 64Mi
---
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
        claimName: feed-single
```

Apply it and wait for the Pod:

```sh
kubectl apply -f feed-single.yaml
kubectl -n starfleet wait --for=condition=Ready pod/feed-writer --timeout=120s
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-03/labs/lab-01 --keep
```

The checks for the claim and the writer pass.

## Step 2: Start the second Pod

Save this as `feed-second.yaml`:

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
        claimName: feed-single
```

Apply it and read the scheduling condition:

```sh
kubectl apply -f feed-second.yaml
kubectl -n starfleet get pod feed-second -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].status}{"\n"}'
```

The Pod stays Pending and the condition is `False`. Run `kubectl -n starfleet describe pod feed-second` to read the scheduler's event.

## Step 3: Read-only reader

Save this as `feed-shared.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: feed-shared
  namespace: starfleet
spec:
  accessModes:
    - ReadOnlyMany
  storageClassName: ""
  volumeName: training-readonly
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: feed-reader
  namespace: starfleet
spec:
  containers:
    - name: reader
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: feed-shared
        readOnly: true
```

Apply it, wait, and try a write that must fail:

```sh
kubectl apply -f feed-shared.yaml
kubectl -n starfleet wait --for=condition=Ready pod/feed-reader --timeout=120s
kubectl -n starfleet exec feed-reader -- sh -c 'echo x > /data/new-file'
```

The last command fails because the mount is read-only. Grade the whole task:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-03/labs/lab-01 --keep
```

If a check fails, read its message: it names the claim, the Pod or the field that is wrong. After you finish, remove the lab with `astrona destroy ats-022-lab-020-03`.
