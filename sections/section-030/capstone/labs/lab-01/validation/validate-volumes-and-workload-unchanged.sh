#!/usr/bin/env bash
# Check: static volumes keep their definition and telemetry-writer still mounts telemetry.
set -uo pipefail

fail=0
for pair in archive-a:cold archive-b:hot; do
  name="${pair%%:*}"
  tier="${pair##*:}"
  size="$(kubectl get pv "$name" -o jsonpath='{.spec.capacity.storage}' 2>/dev/null || true)"
  actual_tier="$(kubectl get pv "$name" -o jsonpath='{.metadata.labels.tier}' 2>/dev/null || true)"
  class="$(kubectl get pv "$name" -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
  if [ "$size" != "500Mi" ] || [ "$actual_tier" != "$tier" ] || [ "$class" != "manual" ]; then
    echo "FAIL: volume $name was changed or removed (size '$size', tier '$actual_tier', class '$class')"
    fail=1
  fi
done

claim="$(kubectl -n starfleet get deployment telemetry-writer -o jsonpath='{.spec.template.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get deployment telemetry-writer -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "$claim" != "telemetry" ] || [ "${ready:-0}" -lt 1 ]; then
  echo "FAIL: deployment telemetry-writer must stay ready and mount telemetry"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: volumes and workload are unchanged"
fi
exit "$fail"
