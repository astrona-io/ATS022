#!/usr/bin/env bash
# Check: old-claim is gone and the Pod holder was stopped (not only the finalizer removed).
set -uo pipefail

if kubectl -n starfleet get pvc old-claim >/dev/null 2>&1; then
  echo "FAIL: claim old-claim still exists"
  exit 1
fi
if kubectl -n starfleet get pod holder >/dev/null 2>&1; then
  echo "FAIL: pod holder still exists. Stop the Pod that uses the claim."
  exit 1
fi
echo "PASS: old-claim and its Pod holder are gone"
