---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Guided Practice: Provision Through A Delayed-Binding StorageClass

Use a host shell with the private kubeconfig for this module playground. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-022-playground-010-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-022-playground-010-01" || exit 1
node_name="astro-ats-022-playground-010-01-control-plane"
worker_name="astro-ats-022-playground-010-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Create StorageClass `training-local` using the kind local-path provisioner, WaitForFirstConsumer binding and Retain reclaim policy. Request 128Mi through claim `class-data` and mount it at `/data` in Pod `class-reader`. The claim must become Bound and a write/read in the consumer must succeed. The local-path practice driver does not represent all Container Storage Interface (CSI) driver capabilities.

Save this as `storageclass-training-local.yaml`:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: training-local
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: class-data
  namespace: starfleet
spec:
  storageClassName: training-local
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 128Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: class-reader
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
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: class-data
```

Apply the scoped correction:

```sh
kubectl apply -f storageclass-training-local.yaml
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n starfleet wait --for=condition=Ready pod/class-reader --timeout=180s
kubectl -n starfleet exec class-reader -- sh -c 'printf stored > /data/result && cat /data/result'
```

Create a class and claim whose storage binds when its consumer can be scheduled. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.


## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
