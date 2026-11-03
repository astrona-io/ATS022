#!/usr/bin/env bash
# Starting state for the retained volumes lab: a Retain PV that is already
# Released, and a dynamic claim used by a running Pod. The PV name behind the
# dynamic claim is recorded in the ConfigMap lab-state for the checks.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/archive-old --timeout=120s
kubectl -n starfleet delete pvc archive-old --wait=true
for _ in $(seq 1 60); do
  phase="$(kubectl get pv training-archive -o jsonpath='{.status.phase}')"
  [ "$phase" = "Released" ] && break
  sleep 2
done
kubectl -n starfleet wait --for=condition=Ready pod/scratch-writer --timeout=180s
scratch_pv="$(kubectl -n starfleet get pvc scratch-data -o jsonpath='{.spec.volumeName}')"
kubectl -n starfleet create configmap lab-state --from-literal=scratchPv="$scratch_pv"
echo "[lab] Ready."
