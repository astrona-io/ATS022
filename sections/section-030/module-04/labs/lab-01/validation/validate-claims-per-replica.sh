#!/usr/bin/env bash
# Check: the volumeClaimTemplate data created one Bound claim per replica.
set -uo pipefail

template="$(kubectl -n starfleet get statefulset crew-log -o jsonpath='{.spec.volumeClaimTemplates[0].metadata.name}' 2>/dev/null || true)"
if [ "$template" != "data" ]; then
  echo "FAIL: the volumeClaimTemplate is named '$template', expected data"
  exit 1
fi

for ordinal in 0 1; do
  claim="data-crew-log-$ordinal"
  phase="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  request="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"
  modes="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null || true)"
  class="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
  if [ "$phase" != "Bound" ] || [ "$request" != "50Mi" ] || [ "$modes" != "ReadWriteOnce" ] || [ "$class" != "standard" ]; then
    echo "FAIL: claim $claim is '${phase:-missing}' with request '$request', modes '$modes', class '$class'; expected Bound, 50Mi, ReadWriteOnce, standard"
    exit 1
  fi
done
echo "PASS: data-crew-log-0 and data-crew-log-1 are Bound"
