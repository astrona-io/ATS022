#!/usr/bin/env bash
# Check: reports-writer and telemetry-writer run, mount their own claim and
# wrote /data/ok.txt.
set -uo pipefail

fail=0
for pair in reports-writer:reports telemetry-writer:telemetry; do
  pod="${pair%%:*}"
  claim="${pair##*:}"
  phase="$(kubectl -n starfleet get pod "$pod" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  used="$(kubectl -n starfleet get pod "$pod" -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null || true)"
  if [ "$phase" != "Running" ]; then
    echo "FAIL: Pod $pod phase is '$phase', expected Running"
    fail=1
    continue
  fi
  if [ "$used" != "$claim" ]; then
    echo "FAIL: Pod $pod uses claim '$used', expected $claim"
    fail=1
    continue
  fi
  if ! kubectl -n starfleet exec "$pod" -- test -s /data/ok.txt 2>/dev/null; then
    echo "FAIL: /data/ok.txt is missing or empty in $pod"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: both Pods run and wrote /data/ok.txt"
fi
exit "$fail"
