#!/usr/bin/env bash
# Playground starting state for module 020/02: a namespace, a ConfigMap, a
# Secret and an idle Pod. Environment only.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/start.yaml"
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=180s
echo "[playground] Ready."
