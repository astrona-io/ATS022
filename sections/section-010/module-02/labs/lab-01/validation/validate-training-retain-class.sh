#!/usr/bin/env bash
# Check: the StorageClass training-retain has the required fields.
set -uo pipefail

fail=0
check_field() {
  local description="$1" path="$2" expected="$3" actual
  actual="$(kubectl get storageclass training-retain -o jsonpath="$path" 2>/dev/null || true)"
  if [ "$actual" != "$expected" ]; then
    echo "FAIL: $description is '$actual', expected '$expected'"
    fail=1
  fi
}

if ! kubectl get storageclass training-retain >/dev/null 2>&1; then
  echo "FAIL: StorageClass training-retain does not exist"
  exit 1
fi
check_field "provisioner" '{.provisioner}' "rancher.io/local-path"
check_field "reclaimPolicy" '{.reclaimPolicy}' "Retain"
check_field "volumeBindingMode" '{.volumeBindingMode}' "WaitForFirstConsumer"
check_field "allowVolumeExpansion" '{.allowVolumeExpansion}' "true"

if [ "$fail" -eq 0 ]; then
  echo "PASS: training-retain has the required fields"
fi
exit "$fail"
