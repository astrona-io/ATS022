#!/usr/bin/env bash
# Check: StatefulSet relay runs 2 replicas, each with a Bound claim from the template store.
set -uo pipefail

ready="$(kubectl -n starfleet get statefulset relay -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
service="$(kubectl -n starfleet get statefulset relay -o jsonpath='{.spec.serviceName}' 2>/dev/null || true)"
template="$(kubectl -n starfleet get statefulset relay -o jsonpath='{.spec.volumeClaimTemplates[0].metadata.name}' 2>/dev/null || true)"

if [ "${ready:-0}" != "2" ] || [ "$service" != "relay" ] || [ "$template" != "store" ]; then
  echo "FAIL: statefulset relay has ready '${ready:-0}', serviceName '$service', template '$template'; expected 2, relay, store"
  exit 1
fi
for ordinal in 0 1; do
  claim="store-relay-$ordinal"
  phase="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  request="$(kubectl -n starfleet get pvc "$claim" -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"
  if [ "$phase" != "Bound" ] || [ "$request" != "50Mi" ]; then
    echo "FAIL: claim $claim is '${phase:-missing}' with request '$request'; expected Bound and 50Mi"
    exit 1
  fi
done
echo "PASS: relay runs with one Bound claim per replica"
