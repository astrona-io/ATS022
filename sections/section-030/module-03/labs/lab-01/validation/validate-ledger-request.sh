#!/usr/bin/env bash
# Check: ledger keeps the contract of the task: class manual, ReadWriteOnce, 100Mi.
set -uo pipefail

class="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
modes="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null || true)"
request="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"

if [ "$class" != "manual" ] || [ "$modes" != "ReadWriteOnce" ] || [ "$request" != "100Mi" ]; then
  echo "FAIL: ledger has class '$class', modes '$modes', request '$request'; expected manual, ReadWriteOnce, 100Mi"
  exit 1
fi
echo "PASS: ledger asks for 100Mi ReadWriteOnce from the class manual"
