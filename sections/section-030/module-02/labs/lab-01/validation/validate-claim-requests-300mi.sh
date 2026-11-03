#!/usr/bin/env bash
# Check: the claim requests at least 300Mi. Reads spec only. The local-path
# provisioner does not resize volumes, so status.capacity is never checked.
set -uo pipefail

request="$(kubectl -n starfleet get pvc data -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"

to_mebibytes() {
  case "$1" in
    *Gi) echo $(( ${1%Gi} * 1024 )) ;;
    *Mi) echo "${1%Mi}" ;;
    *) echo 0 ;;
  esac
}

mebibytes="$(to_mebibytes "$request")"
if [ "$mebibytes" -lt 300 ]; then
  echo "FAIL: claim data requests '$request', expected 300Mi"
  exit 1
fi
echo "PASS: claim data requests $request"
