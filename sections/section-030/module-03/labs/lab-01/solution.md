# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-03/labs/lab-01
```

## Step 1: Read the volumes

List the volumes with their labels, sizes and classes:

```sh
kubectl get pv --show-labels
```

The volume `crate-b` is the only one with the label `tier=fast`. The volume `crate-a` has the same size with the label `tier=slow`, so a claim without a selector can bind to either.

## Step 2: Create the claim ledger with a selector

Save this as `pvc-ledger.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ledger
  namespace: starfleet
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  selector:
    matchLabels:
      tier: fast
  resources:
    requests:
      storage: 100Mi
```

Apply it:

```sh
kubectl apply -f pvc-ledger.yaml
```

Then check the volume that the claim got:

```sh
kubectl -n starfleet get pvc ledger -o jsonpath='{.spec.volumeName}{"\n"}'
```

The command prints `crate-b`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-03/labs/lab-01 --keep
```

The checks `ledger-bound-to-fast-volume`, `ledger-uses-selector` and `ledger-request` now pass.

## Step 3: Find why manifest is Pending

Describe the claim and read its events:

```sh
kubectl -n starfleet describe pvc manifest
```

Compare the claim with the volumes. The claim asks for the class `archive`, the mode `ReadWriteMany` and 5Gi. The volumes have the class `manual`, the mode `ReadWriteOnce` and at most 2Gi. The volume `vault-1` is the only one that can hold 1Gi, so the claim must request the class `manual`, the mode `ReadWriteOnce` and a size above 200Mi and up to 2Gi.

## Step 4: Create manifest again

The fields `storageClassName` and `accessModes` of a claim cannot be edited. Delete the claim:

```sh
kubectl -n starfleet delete pvc manifest
```

Save this as `pvc-manifest.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: manifest
  namespace: starfleet
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Apply it:

```sh
kubectl apply -f pvc-manifest.yaml
```

Then check the volume:

```sh
kubectl -n starfleet get pvc manifest -o jsonpath='{.spec.volumeName}{"\n"}'
```

The command prints `vault-1`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-03/labs/lab-01 --keep
```

All five checks pass. When you are done, remove the lab:

```sh
astrona destroy ats-022-lab-030-03
```
