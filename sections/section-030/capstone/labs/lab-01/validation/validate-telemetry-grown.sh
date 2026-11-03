#!/usr/bin/env bash
# Check: the original claim telemetry requests 250Mi and its class allows expansion.
# Reads spec only. The local-path provisioner does not resize volumes.
set -uo pipefail

expected="$(kubectl -n starfleet get configmap lab-seed -o jsonpath='{.data.claim-uid}' 2>/dev/null || true)"
actual="$(kubectl -n starfleet get pvc telemetry -o jsonpath='{.metadata.uid}' 2>/dev/null || true)"
request="$(kubectl -n starfleet get pvc telemetry -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"
flag="$(kubectl get storageclass training-grow -o jsonpath='{.allowVolumeExpansion}' 2>/dev/null || true)"

to_mebibytes() {
  case "$1" in
    *Gi) echo $(( ${1%Gi} * 1024 )) ;;
    *Mi) echo "${1%Mi}" ;;
    *) echo 0 ;;
  esac
}

if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
  echo "FAIL: claim telemetry is not the original object. Resize it in place."
  exit 1
fi
if [ "$flag" != "true" ]; then
  echo "FAIL: storageclass training-grow has allowVolumeExpansion='$flag', expected true"
  exit 1
fi
if [ "$(to_mebibytes "$request")" -lt 250 ]; then
  echo "FAIL: claim telemetry requests '$request', expected 250Mi"
  exit 1
fi
echo "PASS: claim telemetry requests $request on a class that allows expansion"
