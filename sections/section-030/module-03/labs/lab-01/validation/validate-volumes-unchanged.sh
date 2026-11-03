#!/usr/bin/env bash
# Check: the static volumes keep their size, class, mode and labels.
set -uo pipefail

fail=0
check_volume() {
  local name="$1" size="$2" tier="$3"
  local actual_size actual_class actual_modes actual_tier
  actual_size="$(kubectl get pv "$name" -o jsonpath='{.spec.capacity.storage}' 2>/dev/null || true)"
  actual_class="$(kubectl get pv "$name" -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
  actual_modes="$(kubectl get pv "$name" -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null || true)"
  actual_tier="$(kubectl get pv "$name" -o jsonpath='{.metadata.labels.tier}' 2>/dev/null || true)"
  if [ "$actual_size" != "$size" ] || [ "$actual_class" != "manual" ] || [ "$actual_modes" != "ReadWriteOnce" ] || [ "$actual_tier" != "$tier" ]; then
    echo "FAIL: volume $name was changed or removed (size '$actual_size', class '$actual_class', modes '$actual_modes', tier '$actual_tier')"
    fail=1
  fi
}

check_volume crate-a 200Mi slow
check_volume crate-b 200Mi fast
check_volume vault-1 2Gi ""

if [ "$fail" -eq 0 ]; then
  echo "PASS: the static volumes are unchanged"
fi
exit "$fail"
