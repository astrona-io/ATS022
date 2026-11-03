#!/usr/bin/env bash
# Playground starting state for module 020/04: a Retain PersistentVolume that
# is already Released, and a dynamic claim used by a running Pod.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/start.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/archive-old --timeout=120s
kubectl -n starfleet delete pvc archive-old --wait=true
for _ in $(seq 1 60); do
  phase="$(kubectl get pv playground-archive -o jsonpath='{.status.phase}')"
  [ "$phase" = "Released" ] && break
  sleep 2
done
kubectl -n starfleet wait --for=condition=Ready pod/scratch-writer --timeout=180s
echo "[playground] Ready."
