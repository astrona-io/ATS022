#!/usr/bin/env bash
# Check: claim vault is Bound to the volume labelled tier=hot, chosen by selector.
set -uo pipefail

phase="$(kubectl -n starfleet get pvc vault -o jsonpath='{.status.phase}' 2>/dev/null || true)"
volume="$(kubectl -n starfleet get pvc vault -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc vault -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
modes="$(kubectl -n starfleet get pvc vault -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null || true)"
request="$(kubectl -n starfleet get pvc vault -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"
selector_tier="$(kubectl -n starfleet get pvc vault -o jsonpath='{.spec.selector.matchLabels.tier}' 2>/dev/null || true)"

if [ "$phase" != "Bound" ]; then
  echo "FAIL: claim vault is '${phase:-missing}', expected Bound"
  exit 1
fi
if [ "$volume" != "archive-b" ]; then
  echo "FAIL: claim vault is bound to '$volume', expected archive-b (tier=hot)"
  exit 1
fi
if [ "$class" != "manual" ] || [ "$modes" != "ReadWriteOnce" ] || [ "$request" != "300Mi" ]; then
  echo "FAIL: vault has class '$class', modes '$modes', request '$request'; expected manual, ReadWriteOnce, 300Mi"
  exit 1
fi
if [ "$selector_tier" != "hot" ]; then
  echo "FAIL: claim vault must choose its volume with selector.matchLabels tier: hot"
  exit 1
fi
echo "PASS: claim vault is bound to archive-b by selector"
