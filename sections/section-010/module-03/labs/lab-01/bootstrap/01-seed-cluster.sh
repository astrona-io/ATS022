#!/usr/bin/env bash
# Starting state for the Pending-claims lab. Environment only: it creates two
# claims that are Pending on purpose and the Pods that use them. The faults
# stay in place.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl wait --for=condition=Ready node --all --timeout=180s
echo "[lab] Ready."
