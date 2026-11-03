#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/pvc-vault.yaml"
kubectl apply -f "$DIR/statefulset-relay.yaml"
kubectl patch storageclass training-grow --patch-file "$DIR/storageclass-training-grow-patch.yaml"
kubectl -n starfleet patch pvc telemetry --patch-file "$DIR/pvc-telemetry-patch.yaml"
kubectl -n starfleet delete pod retired-holder
kubectl -n starfleet rollout status statefulset/relay --timeout=240s
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/vault --timeout=60s
echo "[solution] Applied."
