#!/usr/bin/env bash
# Check: claim manifest is Bound to the volume vault-1, with at least 1Gi requested.
set -uo pipefail

phase="$(kubectl -n starfleet get pvc manifest -o jsonpath='{.status.phase}' 2>/dev/null || true)"
volume="$(kubectl -n starfleet get pvc manifest -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)"
request="$(kubectl -n starfleet get pvc manifest -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"

to_mebibytes() {
  case "$1" in
    *Gi) echo $(( ${1%Gi} * 1024 )) ;;
    *Mi) echo "${1%Mi}" ;;
    *) echo 0 ;;
  esac
}

if [ "$phase" != "Bound" ]; then
  echo "FAIL: claim manifest is '${phase:-missing}', expected Bound"
  exit 1
fi
if [ "$volume" != "vault-1" ]; then
  echo "FAIL: claim manifest is bound to '$volume', expected vault-1"
  exit 1
fi
if [ "$(to_mebibytes "$request")" -lt 1024 ]; then
  echo "FAIL: claim manifest requests '$request', expected at least 1Gi"
  exit 1
fi
echo "PASS: claim manifest is bound to vault-1"
