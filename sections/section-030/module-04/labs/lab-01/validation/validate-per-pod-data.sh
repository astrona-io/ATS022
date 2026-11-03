#!/usr/bin/env bash
# Check: each replica wrote its own host name to /data/owner on its own claim.
set -uo pipefail

for ordinal in 0 1; do
  pod="crew-log-$ordinal"
  owner="$(kubectl -n starfleet exec "$pod" -- cat /data/owner 2>/dev/null || true)"
  if [ "$owner" != "$pod" ]; then
    echo "FAIL: /data/owner in $pod holds '$owner', expected $pod"
    exit 1
  fi
  claim="$(kubectl -n starfleet get pod "$pod" -o jsonpath='{.spec.volumes[?(@.name=="data")].persistentVolumeClaim.claimName}' 2>/dev/null || true)"
  if [ "$claim" != "data-crew-log-$ordinal" ]; then
    echo "FAIL: $pod mounts claim '$claim', expected data-crew-log-$ordinal"
    exit 1
  fi
done
echo "PASS: each replica writes to its own claim"
