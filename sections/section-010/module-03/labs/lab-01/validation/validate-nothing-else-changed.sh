#!/usr/bin/env bash
# Check: the decoy class is untouched and no claim in starfleet is Pending.
set -uo pipefail

fail=0
provisioner="$(kubectl get storageclass training-offline -o jsonpath='{.provisioner}' 2>/dev/null || true)"
if [ "$provisioner" != "example.com/no-such-provisioner" ]; then
  echo "FAIL: class training-offline is missing or changed (provisioner '$provisioner')"
  fail=1
fi
pending="$(kubectl -n starfleet get pvc -o jsonpath='{range .items[?(@.status.phase!="Bound")]}{.metadata.name}{" "}{end}' 2>/dev/null || true)"
if [ -n "$pending" ]; then
  echo "FAIL: claims not Bound: $pending"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: no claim is Pending and training-offline is untouched"
fi
exit "$fail"
