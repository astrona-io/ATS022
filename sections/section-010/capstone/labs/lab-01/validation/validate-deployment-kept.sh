#!/usr/bin/env bash
# Check: the probe Deployment has the UID recorded at bootstrap.
set -uo pipefail

saved="$(kubectl -n kube-system get configmap capstone-baseline -o jsonpath='{.data.probeUid}' 2>/dev/null || true)"
current="$(kubectl -n starfleet get deployment probe -o jsonpath='{.metadata.uid}' 2>/dev/null || true)"

if [ -z "$saved" ] || [ -z "$current" ]; then
  echo "FAIL: cannot read the Deployment UID (saved '$saved', current '$current')"
  exit 1
fi
if [ "$saved" != "$current" ]; then
  echo "FAIL: the probe Deployment was deleted and recreated"
  exit 1
fi
echo "PASS: the probe Deployment is the original object"
