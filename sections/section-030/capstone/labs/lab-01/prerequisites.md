# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know how claims bind to volumes, how a StatefulSet creates claims, how a claim is resized, and how a claim in use is protected.

The lab starts a single-node kind cluster (Kubernetes 1.35). The commands for the lab are in the README of this folder.
