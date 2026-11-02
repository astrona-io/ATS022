---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Bind A Claim To An Existing Volume

Bind a named claim without invoking the default dynamic provisioner.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
