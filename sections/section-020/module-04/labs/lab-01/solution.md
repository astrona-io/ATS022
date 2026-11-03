# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab is UNTESTED: the steps follow the reference solution but were not run.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-04/labs/lab-01
```

## Step 1: Rebind the Released volume

Read the volume first. Its `claimRef` still names the deleted claim:

```sh
kubectl get pv training-archive -o jsonpath='{.status.phase}{"\n"}{.spec.claimRef}{"\n"}'
```

Remove the reference with a JSON patch:

```sh
kubectl patch pv training-archive --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
```

Save this as `pvc-archive-restore.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: archive-restore
  namespace: starfleet
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  volumeName: training-archive
  resources:
    requests:
      storage: 64Mi
```

Apply it and wait for the claim:

```sh
kubectl apply -f pvc-archive-restore.yaml
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/archive-restore --timeout=120s
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-020/module-04/labs/lab-01 --keep
```

The checks `archive-rebound` and `archive-still-retained` pass.

## Step 2: Retire scratch-data without losing its volume

Find the volume name. The ConfigMap `lab-state` holds it, and the claim holds it too:

```sh
kubectl -n starfleet get pvc scratch-data -o jsonpath='{.spec.volumeName}{"\n"}'
```

Patch that volume to `Retain` (replace `<PV>` with the name):

```sh
kubectl patch pv <PV> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
```

Delete the Pod first, then the claim:

```sh
kubectl -n starfleet delete pod scratch-writer
kubectl -n starfleet delete pvc scratch-data
```

Check the volume:

```sh
kubectl get pv <PV> -o custom-columns=NAME:.metadata.name,POLICY:.spec.persistentVolumeReclaimPolicy,PHASE:.status.phase
```

The policy is `Retain` and the phase is `Released`. Grade again with the same `astrona submit` command. If `scratch-data` was deleted before the patch, the volume is gone and the lab must be restarted.

After you finish, remove the lab with `astrona destroy ats-022-lab-020-04`.
