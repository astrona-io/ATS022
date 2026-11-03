---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Guided Practice: Bind A Claim To An Existing Volume

Use a host shell with the private kubeconfig for this module playground. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-022-playground-030-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-022-playground-030-01" || exit 1
node_name="astro-ats-022-playground-030-01-control-plane"
worker_name="astro-ats-022-playground-030-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Create 128Mi PersistentVolume `training-static` with Retain reclaim policy and empty storageClassName. Bind claim `static-data` explicitly by volumeName. Run `static-reader` on this lab control-plane node and mount the claim at `/data`. A write/read must succeed. hostPath is used only in this disposable lab; it is not a distributed storage implementation.

Save this as `persistentvolume-training-static.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: training-static
spec:
  capacity:
    storage: 128Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ''
  hostPath:
    path: /var/local/training-static
    type: DirectoryOrCreate
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-data
  namespace: starfleet
spec:
  volumeName: training-static
  storageClassName: ''
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 128Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: static-reader
  namespace: starfleet
spec:
  restartPolicy: Never
  containers:
  - name: reader
    image: docker.io/library/busybox:1.37.0
    command:
    - sh
    - -c
    - sleep 3600
    volumeMounts:
    - name: data
      mountPath: /data
  nodeSelector:
    kubernetes.io/hostname: astro-ats-022-playground-030-01-control-plane
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: static-data
  tolerations:
  - key: node-role.kubernetes.io/control-plane
    operator: Exists
    effect: NoSchedule
```

Apply the scoped correction:

```sh
kubectl apply -f persistentvolume-training-static.yaml
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n starfleet wait --for=condition=Ready pod/static-reader --timeout=180s
kubectl -n starfleet exec static-reader -- sh -c 'printf bound > /data/result && cat /data/result'
```

Bind a named claim without invoking the default dynamic provisioner. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.


## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
