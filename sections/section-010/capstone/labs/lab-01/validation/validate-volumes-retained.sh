#!/usr/bin/env bash
# Check: the PVs behind probe-data and shuttle-data have the Retain policy.
set -uo pipefail

fail=0
for claim in probe-data shuttle-data; do
  volume="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)"
  if [ -z "$volume" ]; then
    echo "FAIL: $claim is not bound to a volume"
    fail=1
    continue
  fi
  policy="$(kubectl get pv "$volume" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null || true)"
  if [ "$policy" != "Retain" ]; then
    echo "FAIL: PV $volume of $claim has reclaim policy '$policy', expected Retain"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: both volumes keep the Retain policy"
fi
exit "$fail"
