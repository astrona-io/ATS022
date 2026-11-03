#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create the new default class first, then remove the default from standard,
# so that the claim created afterwards sees exactly one default.
kubectl apply -f "$DIR/solution.yaml"
kubectl patch storageclass standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl apply -f "$DIR/claim.yaml"
kubectl -n starfleet wait --for=condition=Ready pod/logs-writer --timeout=180s
echo "[solution] Applied."
