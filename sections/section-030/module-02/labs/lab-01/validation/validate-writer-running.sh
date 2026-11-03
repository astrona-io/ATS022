#!/usr/bin/env bash
# Check: the data-writer Deployment still runs and mounts the claim data.
set -uo pipefail

ready="$(kubectl -n starfleet get deployment data-writer -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
claim="$(kubectl -n starfleet get deployment data-writer -o jsonpath='{.spec.template.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null || true)"

if [ "${ready:-0}" -lt 1 ]; then
  echo "FAIL: deployment data-writer has no ready replica"
  exit 1
fi
if [ "$claim" != "data" ]; then
  echo "FAIL: deployment data-writer mounts claim '$claim', expected data"
  exit 1
fi
echo "PASS: data-writer runs with the claim data"
