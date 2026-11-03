#!/usr/bin/env bash
# Check: claim data is the original object, still Bound to the original class.
set -uo pipefail

expected="$(kubectl -n starfleet get configmap lab-seed -o jsonpath='{.data.claim-uid}' 2>/dev/null || true)"
actual="$(kubectl -n starfleet get pvc data -o jsonpath='{.metadata.uid}' 2>/dev/null || true)"
phase="$(kubectl -n starfleet get pvc data -o jsonpath='{.status.phase}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc data -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"

if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
  echo "FAIL: claim data is not the original object. Resize it in place, do not delete it."
  exit 1
fi
if [ "$phase" != "Bound" ]; then
  echo "FAIL: claim data is $phase, expected Bound"
  exit 1
fi
if [ "$class" != "training-grow" ]; then
  echo "FAIL: claim data uses class '$class', expected training-grow"
  exit 1
fi
echo "PASS: claim data is the original Bound claim"
