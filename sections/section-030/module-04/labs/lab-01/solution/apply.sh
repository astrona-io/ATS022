#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/statefulset-crew-log.yaml"
kubectl -n starfleet delete pod holder
kubectl -n starfleet rollout status statefulset/crew-log --timeout=240s
echo "[solution] Applied."
