---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Provision Through A Delayed-Binding StorageClass

Create a class and claim whose storage binds when its consumer can be scheduled.

## Starting state

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-022-lab-010-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-022-lab-010-01-01" || exit 1
node_name="astro-ats-022-lab-010-01-01-control-plane"
worker_name="astro-ats-022-lab-010-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Create StorageClass `training-local` using the kind local-path provisioner, WaitForFirstConsumer binding and Retain reclaim policy. Request 128Mi through claim `class-data` and mount it at `/data` in Pod `class-reader`. The claim must become Bound and a write/read in the consumer must succeed. The local-path practice driver does not represent all Container Storage Interface (CSI) driver capabilities.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
