# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/capstone/labs/lab-01
```

Right after the start, `astrona submit` reports that `volumes-and-workload-unchanged` passes and that the other checks fail.

## Step 1: Bind vault to the hot volume with a selector

Save this as `pvc-vault.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vault
  namespace: starfleet
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  selector:
    matchLabels:
      tier: hot
  resources:
    requests:
      storage: 300Mi
```

Apply it:

```sh
kubectl apply -f pvc-vault.yaml
```

Then check the volume:

```sh
kubectl -n starfleet get pvc vault -o jsonpath='{.spec.volumeName}{"\n"}'
```

The command prints `archive-b`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/capstone/labs/lab-01 --keep
```

The check `vault-bound-to-hot` now passes.

## Step 2: Create the StatefulSet with a claim template

Save this as `statefulset-relay.yaml`:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: relay
  namespace: starfleet
spec:
  serviceName: relay
  replicas: 2
  selector:
    matchLabels:
      app: relay
  template:
    metadata:
      labels:
        app: relay
    spec:
      containers:
      - name: relay
        image: docker.io/library/busybox:1.37.0
        command:
        - sh
        - -c
        - hostname > /store/owner; sleep 36000
        volumeMounts:
        - name: store
          mountPath: /store
  volumeClaimTemplates:
  - metadata:
      name: store
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
kubectl apply -f statefulset-relay.yaml
```

Then wait for the replicas and list the claims:

```sh
kubectl -n starfleet rollout status statefulset/relay --timeout=240s
kubectl -n starfleet get pvc
```

The list contains `store-relay-0` and `store-relay-1`. Grade it with the same `astrona submit` command. The check `relay-claims` now passes.

## Step 3: Grow telemetry in place

The edit of the claim is refused while its class does not allow expansion, so change the class first. Save this as `storageclass-training-grow-patch.yaml`:

```yaml
allowVolumeExpansion: true
```

Apply it:

```sh
kubectl patch storageclass training-grow --patch-file storageclass-training-grow-patch.yaml
```

Save this as `pvc-telemetry-patch.yaml`:

```yaml
spec:
  resources:
    requests:
      storage: 250Mi
```

Apply it:

```sh
kubectl -n starfleet patch pvc telemetry --patch-file pvc-telemetry-patch.yaml
```

Then check the request:

```sh
kubectl -n starfleet get pvc telemetry -o jsonpath='{.spec.resources.requests.storage}{"\n"}'
```

The command prints `250Mi`. The field `status.capacity.storage` can stay at its old value, because the local-path provisioner does not resize volumes. Grade it with the same `astrona submit` command. The check `telemetry-grown` now passes.

## Step 4: Release retired-data

Find the Pod that uses the claim:

```sh
kubectl -n starfleet describe pvc retired-data
```

The field `Used By` lists `retired-holder`. Delete that Pod:

```sh
kubectl -n starfleet delete pod retired-holder
```

Then check the claim:

```sh
kubectl -n starfleet get pvc retired-data
```

The command returns a `NotFound` error. Grade it with the same `astrona submit` command. All five checks pass. When you are done, remove the lab:

```sh
astrona destroy ats-022-capstone-030
```
