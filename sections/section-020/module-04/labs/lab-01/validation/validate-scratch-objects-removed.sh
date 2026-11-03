#!/usr/bin/env bash
# Check: the claim scratch-data and the Pod scratch-writer are gone.
set -uo pipefail
fail=0
if kubectl -n starfleet get pvc scratch-data >/dev/null 2>&1; then
  echo "FAIL: the claim scratch-data still exists"
  fail=1
fi
if kubectl -n starfleet get pod scratch-writer >/dev/null 2>&1; then
  echo "FAIL: the Pod scratch-writer still exists"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: scratch-data and scratch-writer are removed"
exit "$fail"
