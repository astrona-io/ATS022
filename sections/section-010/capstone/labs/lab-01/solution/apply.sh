#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/solution.yaml"
kubectl patch storageclass standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl apply -f "$DIR/shuttle.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=240s
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=180s
echo "[solution] Applied."
