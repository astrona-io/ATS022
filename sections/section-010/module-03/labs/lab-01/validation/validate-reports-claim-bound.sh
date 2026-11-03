#!/usr/bin/env bash
# Check: the claim reports is Bound, 64Mi, and its class has the working
# local-path provisioner.
set -uo pipefail

fail=0
phase="$(kubectl -n starfleet get pvc reports -o jsonpath='{.status.phase}' 2>/dev/null || true)"
class="$(kubectl -n starfleet get pvc reports -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)"
size="$(kubectl -n starfleet get pvc reports -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)"

[ "$phase" = "Bound" ] || { echo "FAIL: PVC reports phase is '$phase', expected Bound"; fail=1; }
[ "$size" = "64Mi" ] || { echo "FAIL: PVC reports requests '$size', expected 64Mi"; fail=1; }
provisioner=""
if [ -n "$class" ]; then
  provisioner="$(kubectl get storageclass "$class" -o jsonpath='{.provisioner}' 2>/dev/null || true)"
fi
[ "$provisioner" = "rancher.io/local-path" ] || { echo "FAIL: class '$class' of reports has provisioner '$provisioner', expected rancher.io/local-path"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "PASS: reports is bound through class $class"
fi
exit "$fail"
