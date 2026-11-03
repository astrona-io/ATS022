#!/usr/bin/env bash
# Check: retired-data and the Pod that held it are gone.
set -uo pipefail

if kubectl -n starfleet get pvc retired-data >/dev/null 2>&1; then
  echo "FAIL: claim retired-data still exists"
  exit 1
fi
if kubectl -n starfleet get pod retired-holder >/dev/null 2>&1; then
  echo "FAIL: pod retired-holder still exists. Stop the Pod that uses the claim."
  exit 1
fi
echo "PASS: retired-data and retired-holder are gone"
