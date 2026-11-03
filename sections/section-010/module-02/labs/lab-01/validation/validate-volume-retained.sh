#!/usr/bin/env bash
# Check: the PV bound to logs-data has the Retain policy.
set -uo pipefail

volume="$(kubectl -n starfleet get pvc logs-data -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)"
if [ -z "$volume" ]; then
  echo "FAIL: logs-data is not bound to a volume"
  exit 1
fi
policy="$(kubectl get pv "$volume" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null || true)"
if [ "$policy" != "Retain" ]; then
  echo "FAIL: PV $volume has reclaim policy '$policy', expected Retain"
  exit 1
fi
echo "PASS: PV $volume keeps the Retain policy"
