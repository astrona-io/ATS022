#!/usr/bin/env bash
# Check: claim feed-single asks only for ReadWriteOncePod and is bound to training-single.
set -uo pipefail
modes="$(kubectl -n starfleet get pvc feed-single -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null)"
phase="$(kubectl -n starfleet get pvc feed-single -o jsonpath='{.status.phase}' 2>/dev/null)"
vol="$(kubectl -n starfleet get pvc feed-single -o jsonpath='{.spec.volumeName}' 2>/dev/null)"
if [ "$modes" != "ReadWriteOncePod" ]; then
  echo "FAIL: claim feed-single has access modes '$modes', expected only ReadWriteOncePod"
  exit 1
fi
if [ "$phase" != "Bound" ] || [ "$vol" != "training-single" ]; then
  echo "FAIL: claim feed-single is '$phase' and bound to '$vol', expected Bound to training-single"
  exit 1
fi
echo "PASS: feed-single is bound to training-single with ReadWriteOncePod"
