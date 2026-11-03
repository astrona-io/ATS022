---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Diagnose Pending Claims And Provisioning Failures

A PersistentVolumeClaim (PVC) in the phase `Pending` is the most common storage problem on a cluster. The phase is the same for four different causes: a class that does not exist, a class whose provisioner is not running, a binding mode that waits for a Pod, and a placement rule that no storage can satisfy. Each cause has its own evidence and its own fix, and restarting a Pod fixes none of them.

This module teaches how to read that evidence and how to repair each cause, including the fields that Kubernetes does not let you edit.

## Learning goals

- Read the events of a Pending claim and name the component that wrote each event.
- Tell an expected wait (`WaitForFirstConsumer`) from a failure.
- Find a claim that names a StorageClass that does not exist.
- Find a class whose provisioner has no running controller.
- Repair a claim by deleting and recreating it, and explain why `storageClassName` cannot be edited.
- Read the logs of the provisioner Pod.

## Before you start

You need to know what a StorageClass, a PVC and a Pod are, and the basics of `kubectl get`, `kubectl describe` and `kubectl logs`.

The playground is a single-node kind cluster. It starts with several claims that are already Pending for different reasons, in the namespace `starfleet`.

## Reading order

1. Reading A Pending Claim
2. Repairing A Pending Claim
3. Summary

Start the playground now and keep it open while you read:

<!-- astrona:playground -->
