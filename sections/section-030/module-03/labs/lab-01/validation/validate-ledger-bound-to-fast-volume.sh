#!/usr/bin/env bash
# Check: claim ledger is Bound to a volume that carries the label tier=fast.
set -uo pipefail

phase="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.status.phase}' 2>/dev/null || true)"
volume="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)"

if [ "$phase" != "Bound" ] || [ -z "$volume" ]; then
  echo "FAIL: claim ledger is '${phase:-missing}', expected Bound"
  exit 1
fi
tier="$(kubectl get pv "$volume" -o jsonpath='{.metadata.labels.tier}' 2>/dev/null || true)"
if [ "$tier" != "fast" ]; then
  echo "FAIL: claim ledger is bound to $volume, whose label tier is '$tier', expected fast"
  exit 1
fi
echo "PASS: claim ledger is bound to $volume (tier=fast)"
