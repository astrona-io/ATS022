# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know volume types, access modes, reclaim policies and the phases of a PersistentVolume.

The lab starts a single-node kind cluster (Kubernetes 1.35) with the namespace `starfleet`, a ConfigMap and a Secret, a Released PersistentVolume `training-ledger`, and a dynamic claim `journal` used by a Pod.
