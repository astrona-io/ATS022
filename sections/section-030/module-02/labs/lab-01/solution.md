# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-02/labs/lab-01
```

Right after the start, `astrona submit` reports that the checks `claim-not-recreated` and `writer-running` pass and that the other two checks fail. The two passing checks guard you against fixes that delete the claim or change the Deployment.

## Step 1: Try the edit and read the error

Request the new size:

```sh
kubectl -n starfleet patch pvc data --type merge -p '{"spec":{"resources":{"requests":{"storage":"300Mi"}}}}'
```

The API server answers with a `Forbidden` error. It says that only dynamically provisioned claims can be resized and that the class must support resize. The claim is dynamically provisioned, so the class is the part to fix.

## Step 2: Allow expansion on the class

Save this as `storageclass-training-grow-patch.yaml`:

```yaml
allowVolumeExpansion: true
```

Apply it:

```sh
kubectl patch storageclass training-grow --patch-file storageclass-training-grow-patch.yaml
```

Then check the field:

```sh
kubectl get storageclass training-grow -o jsonpath='{.allowVolumeExpansion}{"\n"}'
```

The command prints `true`. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-02/labs/lab-01 --keep
```

The check `class-allows-expansion` now passes.

## Step 3: Raise the claim request

Save this as `pvc-data-patch.yaml`:

```yaml
spec:
  resources:
    requests:
      storage: 300Mi
```

Apply it:

```sh
kubectl -n starfleet patch pvc data --patch-file pvc-data-patch.yaml
```

Then check the request:

```sh
kubectl -n starfleet get pvc data -o jsonpath='{.spec.resources.requests.storage}{"\n"}'
```

The command prints `300Mi`. The field `status.capacity.storage` can stay at its old value, because the local-path provisioner does not resize volumes. Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS022.git -c sections/section-030/module-02/labs/lab-01 --keep
```

All four checks pass. When you are done, remove the lab:

```sh
astrona destroy ats-022-lab-030-02
```
