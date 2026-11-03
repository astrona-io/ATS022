#!/usr/bin/env bash
# Check: the volume that backed scratch-data survived the claim deletion as a Released Retain volume.
set -uo pipefail
pv="$(kubectl -n starfleet get configmap lab-state -o jsonpath='{.data.scratchPv}' 2>/dev/null)"
if [ -z "$pv" ]; then
  echo "FAIL: the ConfigMap lab-state in starfleet is missing; do not delete it"
  exit 1
fi
if ! kubectl get pv "$pv" >/dev/null 2>&1; then
  echo "FAIL: the volume $pv no longer exists; the policy must be Retain before the claim is deleted"
  exit 1
fi
policy="$(kubectl get pv "$pv" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}')"
phase="$(kubectl get pv "$pv" -o jsonpath='{.status.phase}')"
ref="$(kubectl get pv "$pv" -o jsonpath='{.spec.claimRef.name}')"
if [ "$policy" != "Retain" ]; then
  echo "FAIL: volume $pv has policy '$policy', expected Retain"
  exit 1
fi
if [ "$phase" != "Released" ] || [ "$ref" != "scratch-data" ]; then
  echo "FAIL: volume $pv is '$phase' with claimRef '$ref'; expected Released with claimRef scratch-data"
  exit 1
fi
echo "PASS: volume $pv survived the deletion of scratch-data as Released with Retain"
