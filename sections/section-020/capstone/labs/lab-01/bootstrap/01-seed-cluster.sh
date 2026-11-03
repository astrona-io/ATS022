#!/usr/bin/env bash
# Starting state for the section capstone. Environment only. It creates the
# settings objects, a Released Retain PV with an access mode of one Pod, and a
# dynamic claim in use. The dynamic PV name is stored in the ConfigMap lab-state.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/ledger-old --timeout=120s
kubectl -n starfleet delete pvc ledger-old --wait=true
for _ in $(seq 1 60); do
  phase="$(kubectl get pv training-ledger -o jsonpath='{.status.phase}')"
  [ "$phase" = "Released" ] && break
  sleep 2
done
kubectl -n starfleet wait --for=condition=Ready pod/journal-writer --timeout=180s
journal_pv="$(kubectl -n starfleet get pvc journal -o jsonpath='{.spec.volumeName}')"
kubectl -n starfleet create configmap lab-state --from-literal=journalPv="$journal_pv"
echo "[lab] Ready."
