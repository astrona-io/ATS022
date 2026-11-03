---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Mount Claims In Workloads And Protect Them

A claim holds data only when a workload mounts it, and a claim that a workload still mounts cannot be deleted at will. This module shows how Pods, Deployments and StatefulSets use claims, how a StatefulSet creates one claim per replica, and how Kubernetes blocks the removal of a claim that is in use.

## Learning goals

- Mount a claim in a Pod with `claimName`, `readOnly` and `subPath`.
- Explain why a Deployment with one claim shares that claim between replicas.
- Create one claim per replica with `volumeClaimTemplates` in a StatefulSet, and name the claims.
- Explain what happens to the claims when a StatefulSet is scaled down or deleted.
- Explain storage object in use protection and the finalizers `kubernetes.io/pvc-protection` and `kubernetes.io/pv-protection`.
- Find the Pod that holds a claim and release a Terminating claim in the right order.

## Before you start

You need to know what a PersistentVolumeClaim (PVC) is, how a Pod is defined, and how `kubectl get` and `kubectl delete` work.

The playground is a single-node kind cluster. It has the claim `old-claim` and the Pod `holder` that mounts it in the `starfleet` namespace, plus a headless Service `beacon-log` for the StatefulSet that you create. A headless Service is a Service with `clusterIP: None`. It gives each StatefulSet Pod a stable DNS name.

## Reading order

1. Mount Claims In Pods, Deployments And StatefulSets
2. Storage Object In Use Protection
3. Summary

Start your playground now and keep it running while you read:

<!-- astrona:playground -->
