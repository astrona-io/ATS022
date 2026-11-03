#!/usr/bin/env bash
# Starting state for the volume types lab. Environment only: it creates the
# namespace, the ConfigMap and the Secret. The Pod is the learner's task.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
echo "[lab] Ready."
