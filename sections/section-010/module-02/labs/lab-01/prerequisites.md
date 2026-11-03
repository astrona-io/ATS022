# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know what a StorageClass, a PersistentVolumeClaim and a Pod are.

The lab starts a single-node kind cluster (Kubernetes 1.35) with the namespaces `starfleet` and `outpost`.
