#!/usr/bin/env bash
# Starting state for the claim binding lab. Environment only: it creates three
# static volumes and the Pending claim `manifest`. It does not create the claim
# `ledger` that the learner must write.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/bootstrap/manifests/lab-start.yaml"
for volume in crate-a crate-b vault-1; do
  kubectl wait --for=jsonpath='{.status.phase}'=Available "pv/$volume" --timeout=60s
done
echo "[lab] Ready."
