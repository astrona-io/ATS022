---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Provision Through A Delayed-Binding StorageClass

Create a class and claim whose storage binds when its consumer can be scheduled.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
