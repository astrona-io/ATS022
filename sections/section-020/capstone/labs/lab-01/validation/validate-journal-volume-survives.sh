#!/usr/bin/env bash
# Check: the volume that backed journal survived as Released with Retain.
set -uo pipefail
pv="$(kubectl -n starfleet get configmap lab-state -o jsonpath='{.data.journalPv}' 2>/dev/null)"
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
if [ "$policy" != "Retain" ] || [ "$phase" != "Released" ] || [ "$ref" != "journal" ]; then
  echo "FAIL: volume $pv is policy '$policy', phase '$phase', claimRef '$ref'; expected Retain, Released, journal"
  exit 1
fi
echo "PASS: volume $pv survived as Released with Retain"
