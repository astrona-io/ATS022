#!/usr/bin/env bash
# Check: the claim journal and the Pod journal-writer are gone.
set -uo pipefail
fail=0
if kubectl -n starfleet get pvc journal >/dev/null 2>&1; then
  echo "FAIL: the claim journal still exists"
  fail=1
fi
if kubectl -n starfleet get pod journal-writer >/dev/null 2>&1; then
  echo "FAIL: the Pod journal-writer still exists"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: journal and journal-writer are removed"
exit "$fail"
