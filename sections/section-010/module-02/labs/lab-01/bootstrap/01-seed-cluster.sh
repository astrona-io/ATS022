#!/usr/bin/env bash
# Starting state for the StorageClass lab. Environment only: it creates the
# namespaces and a decoy class. It does not create the class, claim or Pod
# that the learner must write.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl wait --for=condition=Ready node --all --timeout=180s
echo "[lab] Ready."
