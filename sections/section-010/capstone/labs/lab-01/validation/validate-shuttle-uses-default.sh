#!/usr/bin/env bash
# Check: shuttle-data is Bound, 32Mi, got fast-retain, and Pod shuttle wrote
# /data/log.txt.
set -uo pipefail

fail=0
phase="$(kubectl -n starfleet get pvc shuttle-data -o jsonpath='{.status.phase}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc shuttle-data -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
size="$(kubectl -n starfleet get pvc shuttle-data -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"
pod="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.status.phase}' 2>/dev/null || true)"
used="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null || true)"

[ "$phase" = "Bound" ] || { echo "FAIL: PVC shuttle-data phase is '$phase', expected Bound"; fail=1; }
[ "$class" = "fast-retain" ] || { echo "FAIL: PVC shuttle-data class is '$class', expected fast-retain"; fail=1; }
[ "$size" = "32Mi" ] || { echo "FAIL: PVC shuttle-data requests '$size', expected 32Mi"; fail=1; }
[ "$pod" = "Running" ] || { echo "FAIL: Pod shuttle phase is '$pod', expected Running"; fail=1; }
[ "$used" = "shuttle-data" ] || { echo "FAIL: Pod shuttle uses claim '$used', expected shuttle-data"; fail=1; }
if [ "$fail" -eq 0 ] && ! kubectl -n starfleet exec shuttle -- test -s /data/log.txt 2>/dev/null; then
  echo "FAIL: /data/log.txt is missing or empty in shuttle"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: shuttle-data uses the default class and shuttle wrote /data/log.txt"
fi
exit "$fail"
