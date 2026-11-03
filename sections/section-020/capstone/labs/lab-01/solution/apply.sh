#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl patch pv training-ledger --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'
kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet wait --for=condition=Ready pod/probe-logger --timeout=180s
kubectl -n starfleet wait --for=condition=Ready pod/ledger-writer --timeout=180s
journal_pv="$(kubectl -n starfleet get configmap lab-state -o jsonpath='{.data.journalPv}')"
kubectl patch pv "$journal_pv" -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
kubectl -n starfleet delete pod journal-writer --wait=true
kubectl -n starfleet delete pvc journal --wait=true
echo "[solution] Applied."
