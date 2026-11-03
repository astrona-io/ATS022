# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know what a Pod, a ConfigMap and a Secret are, and how `kubectl exec` works.

The lab starts a single-node kind cluster (Kubernetes 1.35) with the namespace `starfleet`, the ConfigMap `scout-settings` and the Secret `scout-token`.
