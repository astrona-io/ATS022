#!/usr/bin/env bash
# Check: training-archive is Bound to the new claim archive-restore.
set -uo pipefail
phase="$(kubectl get pv training-archive -o jsonpath='{.status.phase}' 2>/dev/null)"
ref="$(kubectl get pv training-archive -o jsonpath='{.spec.claimRef.namespace}/{.spec.claimRef.name}' 2>/dev/null)"
cphase="$(kubectl -n starfleet get pvc archive-restore -o jsonpath='{.status.phase}' 2>/dev/null)"
cvol="$(kubectl -n starfleet get pvc archive-restore -o jsonpath='{.spec.volumeName}' 2>/dev/null)"
if [ "$phase" != "Bound" ] || [ "$ref" != "starfleet/archive-restore" ]; then
  echo "FAIL: training-archive is '$phase' with claimRef '$ref'; expected Bound to starfleet/archive-restore"
  exit 1
fi
if [ "$cphase" != "Bound" ] || [ "$cvol" != "training-archive" ]; then
  echo "FAIL: claim archive-restore is '$cphase' on volume '$cvol'"
  exit 1
fi
echo "PASS: archive-restore is Bound to training-archive"
