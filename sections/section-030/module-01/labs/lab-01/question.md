---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Bind A Claim To An Existing Volume

Bind a named claim without invoking the default dynamic provisioner.

## Starting state

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-022-lab-030-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-022-lab-030-01-01" || exit 1
node_name="astro-ats-022-lab-030-01-01-control-plane"
worker_name="astro-ats-022-lab-030-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Create 128Mi PersistentVolume `training-static` with Retain reclaim policy and empty storageClassName. Bind claim `static-data` explicitly by volumeName. Run `static-reader` on this lab control-plane node and mount the claim at `/data`. A write/read must succeed. hostPath is used only in this disposable lab; it is not a distributed storage implementation.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
