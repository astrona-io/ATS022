# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab is UNTESTED: the steps follow the reference solution but were not run.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-02/labs/lab-01
```

## Step 1: Write the Pod

The Pod needs the two containers, a shared `emptyDir` in memory with a size limit, and one `projected` volume with two sources. The `mode` of the Secret item sets the file permission to `0400` (octal).

Save this as `pod-scout-relay.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: scout-relay
  namespace: starfleet
spec:
  containers:
    - name: writer
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: shared
          mountPath: /shared
    - name: reader
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: shared
          mountPath: /shared
        - name: settings
          mountPath: /etc/scout
          readOnly: true
  volumes:
    - name: shared
      emptyDir:
        medium: Memory
        sizeLimit: 64Mi
    - name: settings
      projected:
        sources:
          - configMap:
              name: scout-settings
          - secret:
              name: scout-token
              items:
                - key: token
                  path: token
                  mode: 0400
```

Apply it and wait for the Pod:

```sh
kubectl apply -f pod-scout-relay.yaml
kubectl -n starfleet wait --for=condition=Ready pod/scout-relay --timeout=120s
```

Check the files and the mode from the `reader` container:

```sh
kubectl -n starfleet exec scout-relay -c reader -- ls /etc/scout
kubectl -n starfleet exec scout-relay -c reader -- stat -L -c '%a' /etc/scout/token
```

The second command prints `400`.

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-02/labs/lab-01 --keep
```

## Step 2: Check the shared directory

Write in `writer` and read in `reader`:

```sh
kubectl -n starfleet exec scout-relay -c writer -- sh -c 'echo ping > /shared/message'
kubectl -n starfleet exec scout-relay -c reader -- cat /shared/message
```

The second command prints `ping`. If a check fails, read its message: it names the volume, the field or the file that is wrong. A Pod stuck in `ContainerCreating` means a source object name is wrong. Run `kubectl -n starfleet describe pod scout-relay` and read the events.

After you finish, remove the lab with `astrona destroy ats-022-lab-020-02`.
