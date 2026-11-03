---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Released Volumes And Rebinding

A PV that Kubernetes kept with `Retain` holds data that someone wants back. The administrator expects to create a new claim and see the data. The new claim stays Pending instead. The cause is a field on the PV that still points at the deleted claim, and clearing that field is the step that makes the volume usable again.

## The Released phase

A PV has a phase in `status.phase`: `Available` (not bound), `Bound` (bound to a claim), `Released` (its claim was deleted, but the volume is not reclaimed yet) and `Failed` (automatic reclamation failed). While a PV is bound, `spec.claimRef` holds the namespace, name and UID of the claim. When the claim is deleted under `Retain`, the PV controller keeps `claimRef` unchanged and sets the phase to `Released`.

Look at the volume in the playground:

<!-- astrona:playground:renew -->

```sh
kubectl get pv playground-archive -o jsonpath='{.status.phase}{"\n"}{.spec.claimRef}{"\n"}'
```

The phase is `Released`, and `claimRef` still names the deleted claim `archive-old` with its old UID. The data on the volume is still there. The volume does not bind again, for two reasons: its `claimRef` points at a claim UID that no longer exists, and the PV controller treats a Released volume as already claimed. Kubernetes does not clear the reference by itself, because the previous owner's data is still on the volume, and a new claim could read it. The administrator has to decide that reuse is safe.

## A new claim stays Pending

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
  volumeName: playground-archive
  resources:
    requests:
      storage: 64Mi
```

Apply it:

```sh
kubectl apply -f pvc-archive-restore.yaml
```

Then read the phase:

```sh
kubectl -n starfleet get pvc archive-restore -o jsonpath='{.status.phase}{"\n"}'
```

The claim stays `Pending`, because the volume it names is Released.

## Make the volume bindable again

There are two ways. The first is to delete the PV object and create it again with the same definition. For a hostPath or network volume, deleting the PV object does not delete the data, because the object only describes the volume. For a dynamically provisioned volume, deleting the PV object can leave the backing storage behind, and a new PV object must describe that same storage exactly.

The second way keeps the object and removes the reference with a JSON patch:

```sh
kubectl patch pv playground-archive --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
```

Without a `claimRef`, the PV controller sets the phase to `Available`. The pending claim `archive-restore` names the volume with `volumeName`, so the controller binds them. Check:

```sh
kubectl get pv playground-archive -o jsonpath='{.status.phase} {.spec.claimRef.name}{"\n"}'
```

The phase becomes `Bound` and `claimRef.name` is `archive-restore`.

Removing the whole `claimRef` leaves the volume open to any claim that matches its size, class and access modes. To reserve the volume for one claim, keep `claimRef` but delete its `uid` and `resourceVersion` fields. A `claimRef` with only `namespace` and `name` binds only to a claim with that name, even if the claim is created later:

```sh
kubectl patch pv playground-archive --type=json -p '[{"op":"remove","path":"/spec/claimRef/uid"},{"op":"remove","path":"/spec/claimRef/resourceVersion"}]'
```

A claim can also pick a volume with `selector` and labels on the PV, which avoids naming the volume. The data on a reused volume is the previous owner's data, so clean or check it before you give it to a different team.

## Check what is waiting before you reuse a volume

A volume without a `claimRef` is open to every claim that fits it. Before you clear the reference, list the claims that have no volume yet, so that the volume goes to the claim you intend:

```sh
kubectl get pvc -A
```

The list shows each claim with its namespace, status, volume, capacity and class. Waiting claims have the status `Pending`. A claim that names the volume with `volumeName` is the one to expect. A claim without `volumeName` and with a matching size, empty class and access modes can also take the volume, so compare the entries with the volume's capacity, `storageClassName` and `accessModes`. After the volume is `Bound`, confirm that `claimRef.name` is the claim you intended.

You now know the full cycle: `Retain` keeps the volume, `claimRef` keeps it reserved, and removing the reference makes it available again. The PV stays `Retain` after the rebind, so the next claim deletion repeats the cycle.

## Common pitfalls

> [!WARNING]
> A Released volume does not bind, even to a claim that names it with `volumeName`. Removing the `claimRef` makes the volume available to any matching claim, so check which claims are waiting first. Deleting a PV object does not always delete the data, and for dynamic volumes it can leave the backing storage orphaned.
