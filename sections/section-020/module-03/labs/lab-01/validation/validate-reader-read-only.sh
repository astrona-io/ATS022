#!/usr/bin/env bash
# Check: feed-reader uses the ReadOnlyMany claim with readOnly: true and cannot write.
set -uo pipefail
NS=starfleet
modes="$(kubectl -n $NS get pvc feed-shared -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null)"
phase="$(kubectl -n $NS get pvc feed-shared -o jsonpath='{.status.phase}' 2>/dev/null)"
vol="$(kubectl -n $NS get pvc feed-shared -o jsonpath='{.spec.volumeName}' 2>/dev/null)"
ro="$(kubectl -n $NS get pod feed-reader -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim.claimName=="feed-shared")].persistentVolumeClaim.readOnly}' 2>/dev/null)"
ready="$(kubectl -n $NS get pod feed-reader -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
if [ "$modes" != "ReadOnlyMany" ] || [ "$phase" != "Bound" ] || [ "$vol" != "training-readonly" ]; then
  echo "FAIL: claim feed-shared must be ReadOnlyMany and Bound to training-readonly (found '$modes', '$phase', '$vol')"
  exit 1
fi
if [ "$ro" != "true" ]; then
  echo "FAIL: feed-reader must set readOnly: true on its persistentVolumeClaim volume"
  exit 1
fi
if [ "$ready" != "True" ]; then
  echo "FAIL: pod feed-reader is not Ready"
  exit 1
fi
if kubectl -n $NS exec feed-reader -- sh -c 'echo x > /data/new-file' >/dev/null 2>&1; then
  echo "FAIL: feed-reader could write to /data"
  exit 1
fi
echo "PASS: feed-reader mounts feed-shared read-only and cannot write"
