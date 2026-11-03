#!/usr/bin/env bash
# Check: the claim logs-data is bound, requests 64Mi and uses training-retain.
set -uo pipefail

fail=0
phase="$(kubectl -n starfleet get pvc logs-data -o jsonpath='{.status.phase}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc logs-data -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
size="$(kubectl -n starfleet get pvc logs-data -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"

[ "$phase" = "Bound" ] || { echo "FAIL: PVC logs-data phase is '$phase', expected Bound"; fail=1; }
[ "$class" = "training-retain" ] || { echo "FAIL: PVC logs-data class is '$class', expected training-retain"; fail=1; }
[ "$size" = "64Mi" ] || { echo "FAIL: PVC logs-data requests '$size', expected 64Mi"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "PASS: logs-data is bound to training-retain"
fi
exit "$fail"
