#!/usr/bin/env bash
# Check: the reused volume keeps its Retain policy and the same object (not recreated with another policy).
set -uo pipefail
policy="$(kubectl get pv training-archive -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)"
path="$(kubectl get pv training-archive -o jsonpath='{.spec.hostPath.path}' 2>/dev/null)"
if [ "$policy" != "Retain" ]; then
  echo "FAIL: training-archive has reclaim policy '$policy', expected Retain"
  exit 1
fi
if [ "$path" != "/var/local/training-archive" ]; then
  echo "FAIL: training-archive points at '$path', expected /var/local/training-archive"
  exit 1
fi
echo "PASS: training-archive keeps Retain and its original path"
