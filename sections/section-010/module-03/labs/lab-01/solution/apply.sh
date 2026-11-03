#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl -n starfleet delete pod reports-writer telemetry-writer --wait=true
kubectl -n starfleet delete pvc reports telemetry --wait=true
kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet wait --for=condition=Ready pod/reports-writer pod/telemetry-writer --timeout=180s
echo "[solution] Applied."
