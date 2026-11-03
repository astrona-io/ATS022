#!/usr/bin/env bash
# Check: feed-writer runs on feed-single and can write to /data.
set -uo pipefail
NS=starfleet
claim="$(kubectl -n $NS get pod feed-writer -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)"
ready="$(kubectl -n $NS get pod feed-writer -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
if [ "$claim" != "feed-single" ]; then
  echo "FAIL: pod feed-writer must use the claim feed-single (found '$claim')"
  exit 1
fi
if [ "$ready" != "True" ]; then
  echo "FAIL: pod feed-writer is not Ready"
  exit 1
fi
if ! kubectl -n $NS exec feed-writer -- sh -c 'echo ok > /data/owner && cat /data/owner' 2>/dev/null | grep -q ok; then
  echo "FAIL: feed-writer cannot write to /data"
  exit 1
fi
echo "PASS: feed-writer is Ready and writes to the claim"
