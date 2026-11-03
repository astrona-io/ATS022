#!/usr/bin/env bash
# Check: ledger picks its volume with a selector on tier=fast, not with volumeName.
set -uo pipefail

selector="$(kubectl -n starfleet get pvc ledger -o json 2>/dev/null | python3 -c '
import json, sys
spec = json.load(sys.stdin)["spec"]
selector = spec.get("selector") or {}
labels = selector.get("matchLabels") or {}
expressions = selector.get("matchExpressions") or []
in_fast = any(e.get("key") == "tier" and e.get("operator") == "In" and e.get("values") == ["fast"] for e in expressions)
print("yes" if labels.get("tier") == "fast" or in_fast else "no")
' 2>/dev/null || echo no)"

preset="$(kubectl -n starfleet get pvc ledger -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null | grep -c volumeName || true)"

if [ "$selector" != "yes" ]; then
  echo "FAIL: claim ledger has no selector that requires tier=fast"
  exit 1
fi
if [ "${preset:-0}" != "0" ]; then
  echo "FAIL: claim ledger sets volumeName. Use the selector only."
  exit 1
fi
echo "PASS: claim ledger selects its volume by label"
