#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl patch storageclass training-grow --patch-file "$DIR/storageclass-training-grow-patch.yaml"
kubectl -n starfleet patch pvc data --patch-file "$DIR/pvc-data-patch.yaml"
echo "[solution] Applied."
