#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl patch pv training-archive --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/archive-restore --timeout=120s
scratch_pv="$(kubectl -n starfleet get configmap lab-state -o jsonpath='{.data.scratchPv}')"
kubectl patch pv "$scratch_pv" -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
kubectl -n starfleet delete pod scratch-writer --wait=true
kubectl -n starfleet delete pvc scratch-data --wait=true
echo "[solution] Applied."
