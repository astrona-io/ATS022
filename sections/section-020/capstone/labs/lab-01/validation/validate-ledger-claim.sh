#!/usr/bin/env bash
# Check: ledger-current is ReadWriteOncePod, bound to training-ledger, and ledger-writer runs on it.
set -uo pipefail
NS=starfleet
modes="$(kubectl -n $NS get pvc ledger-current -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null)"
phase="$(kubectl -n $NS get pvc ledger-current -o jsonpath='{.status.phase}' 2>/dev/null)"
vol="$(kubectl -n $NS get pvc ledger-current -o jsonpath='{.spec.volumeName}' 2>/dev/null)"
if [ "$modes" != "ReadWriteOncePod" ] || [ "$phase" != "Bound" ] || [ "$vol" != "training-ledger" ]; then
  echo "FAIL: claim ledger-current must be ReadWriteOncePod and Bound to training-ledger (found '$modes', '$phase', '$vol')"
  exit 1
fi
claim="$(kubectl -n $NS get pod ledger-writer -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)"
ready="$(kubectl -n $NS get pod ledger-writer -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
if [ "$claim" != "ledger-current" ] || [ "$ready" != "True" ]; then
  echo "FAIL: pod ledger-writer must use ledger-current and be Ready (found claim '$claim', Ready '$ready')"
  exit 1
fi
if ! kubectl -n $NS exec ledger-writer -- sh -c 'echo ok > /ledger/owner && cat /ledger/owner' 2>/dev/null | grep -q ok; then
  echo "FAIL: ledger-writer cannot write to /ledger"
  exit 1
fi
echo "PASS: ledger-current is bound and ledger-writer writes to it"
