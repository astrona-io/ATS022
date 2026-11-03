#!/usr/bin/env bash
# Check: the probe Deployment is available, uses probe-data in class
# fast-retain and wrote /data/boot.txt.
set -uo pipefail

fail=0
available="$(kubectl -n starfleet get deployment probe -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"
phase="$(kubectl -n starfleet get pvc probe-data -o jsonpath='{.status.phase}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc probe-data -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"

[ "${available:-0}" -ge 1 ] 2>/dev/null || { echo "FAIL: Deployment probe has no available replica"; fail=1; }
[ "$phase" = "Bound" ] || { echo "FAIL: PVC probe-data phase is '$phase', expected Bound"; fail=1; }
[ "$class" = "fast-retain" ] || { echo "FAIL: PVC probe-data class is '$class', expected fast-retain"; fail=1; }
if [ "$fail" -eq 0 ] && ! kubectl -n starfleet exec deploy/probe -- test -s /data/boot.txt 2>/dev/null; then
  echo "FAIL: /data/boot.txt is missing or empty in the probe Pod"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: probe is available on probe-data"
fi
exit "$fail"
