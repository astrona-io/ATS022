---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Choose Ephemeral And Projected Volume Types

A Pod does not only store data. It also needs scratch space, configuration files, credentials and facts about itself. Kubernetes serves each of these through a different volume type, and each type has its own lifetime, its own owner and its own limits. Choosing the wrong type loses data, leaks a node path into a Pod, or leaves a configuration file that never updates.

## Learning Goals

- Choose between `emptyDir`, `hostPath`, `configMap`, `secret`, `downwardAPI` and `projected` volumes for a stated requirement.
- Set `medium`, `sizeLimit`, `defaultMode`, `items`, `optional` and `readOnly` correctly.
- Predict when a mounted file changes after its source object changes, and when it does not.
- Share a volume between containers of one Pod and limit what each container may write.

## Before You Start

You need to know what a Pod, a container and a namespace are, and how `kubectl apply` and `kubectl exec` work. The module playground has the namespace `starfleet`, the ConfigMap `scout-settings`, the Secret `scout-token` and an idle Pod `shuttle`.

## Reading Order

1. Scratch Space And Node Paths: `emptyDir`, `hostPath` and `subPath`
2. Configuration, Secrets And Projected Volumes
3. Summary

<!-- astrona:playground -->
