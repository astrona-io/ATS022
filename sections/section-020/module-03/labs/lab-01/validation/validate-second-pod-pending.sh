#!/usr/bin/env bash
# Check: feed-second uses the same RWOP claim and stays unscheduled.
set -uo pipefail
NS=starfleet
claim="$(kubectl -n $NS get pod feed-second -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)"
phase="$(kubectl -n $NS get pod feed-second -o jsonpath='{.status.phase}' 2>/dev/null)"
sched="$(kubectl -n $NS get pod feed-second -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].status}' 2>/dev/null)"
node="$(kubectl -n $NS get pod feed-second -o jsonpath='{.spec.nodeName}' 2>/dev/null)"
if [ "$claim" != "feed-single" ]; then
  echo "FAIL: pod feed-second must use the claim feed-single (found '$claim')"
  exit 1
fi
if [ "$phase" != "Pending" ] || [ "$sched" != "False" ] || [ -n "$node" ]; then
  echo "FAIL: feed-second is phase '$phase', PodScheduled '$sched', node '$node'; expected Pending, False and no node"
  exit 1
fi
echo "PASS: feed-second is Pending and not scheduled while feed-single is in use"
