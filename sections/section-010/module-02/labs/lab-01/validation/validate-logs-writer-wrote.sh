#!/usr/bin/env bash
# Check: Pod logs-writer runs, mounts logs-data and wrote /data/written.txt.
set -uo pipefail

phase="$(kubectl -n starfleet get pod logs-writer -o jsonpath='{.status.phase}' 2>/dev/null || true)"
claim="$(kubectl -n starfleet get pod logs-writer -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null || true)"

if [ "$phase" != "Running" ]; then
  echo "FAIL: Pod logs-writer phase is '$phase', expected Running"
  exit 1
fi
if [ "$claim" != "logs-data" ]; then
  echo "FAIL: Pod logs-writer uses claim '$claim', expected logs-data"
  exit 1
fi
if ! kubectl -n starfleet exec logs-writer -- test -s /data/written.txt 2>/dev/null; then
  echo "FAIL: /data/written.txt is missing or empty in logs-writer"
  exit 1
fi
echo "PASS: logs-writer wrote /data/written.txt"
