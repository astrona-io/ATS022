#!/usr/bin/env bash
# Check: the StorageClass of the claim allows expansion, and it is still the
# same class (not a replacement with another provisioner).
set -uo pipefail

flag="$(kubectl get storageclass training-grow -o jsonpath='{.allowVolumeExpansion}' 2>/dev/null || true)"
provisioner="$(kubectl get storageclass training-grow -o jsonpath='{.provisioner}' 2>/dev/null || true)"

if [ "$flag" != "true" ]; then
  echo "FAIL: storageclass training-grow has allowVolumeExpansion='$flag', expected true"
  exit 1
fi
if [ "$provisioner" != "rancher.io/local-path" ]; then
  echo "FAIL: storageclass training-grow has provisioner '$provisioner'"
  exit 1
fi
echo "PASS: training-grow allows volume expansion"
