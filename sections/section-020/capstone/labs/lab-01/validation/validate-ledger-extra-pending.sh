#!/usr/bin/env bash
# Check: ledger-extra uses the same claim and stays Pending and unscheduled.
set -uo pipefail
NS=starfleet
claim="$(kubectl -n $NS get pod ledger-extra -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)"
phase="$(kubectl -n $NS get pod ledger-extra -o jsonpath='{.status.phase}' 2>/dev/null)"
sched="$(kubectl -n $NS get pod ledger-extra -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].status}' 2>/dev/null)"
node="$(kubectl -n $NS get pod ledger-extra -o jsonpath='{.spec.nodeName}' 2>/dev/null)"
if [ "$claim" != "ledger-current" ]; then
  echo "FAIL: pod ledger-extra must use the claim ledger-current (found '$claim')"
  exit 1
fi
if [ "$phase" != "Pending" ] || [ "$sched" != "False" ] || [ -n "$node" ]; then
  echo "FAIL: ledger-extra is '$phase', PodScheduled '$sched', node '$node'; expected Pending, False and no node"
  exit 1
fi
echo "PASS: ledger-extra is Pending and not scheduled"
