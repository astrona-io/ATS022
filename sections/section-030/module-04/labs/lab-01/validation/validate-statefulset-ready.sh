#!/usr/bin/env bash
# Check: StatefulSet crew-log has 2 ready replicas and uses the Service crew-log.
set -uo pipefail

replicas="$(kubectl -n starfleet get statefulset crew-log -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get statefulset crew-log -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
service="$(kubectl -n starfleet get statefulset crew-log -o jsonpath='{.spec.serviceName}' 2>/dev/null || true)"

if [ "$replicas" != "2" ] || [ "${ready:-0}" != "2" ]; then
  echo "FAIL: statefulset crew-log has replicas '$replicas' and ready '${ready:-0}', expected 2 and 2"
  exit 1
fi
if [ "$service" != "crew-log" ]; then
  echo "FAIL: statefulset crew-log has serviceName '$service', expected crew-log"
  exit 1
fi
echo "PASS: statefulset crew-log has 2 ready replicas"
