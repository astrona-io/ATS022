#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/pvc-ledger.yaml"
kubectl -n starfleet delete pvc manifest --wait=true
kubectl apply -f "$DIR/pvc-manifest.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/ledger pvc/manifest --timeout=60s
echo "[solution] Applied."
