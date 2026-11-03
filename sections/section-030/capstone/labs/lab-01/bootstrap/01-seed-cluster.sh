#!/usr/bin/env bash
# Starting state for the section capstone. Environment only: static volumes, a
# claim that needs growth, a headless Service and a claim stuck in Terminating.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/bootstrap/manifests/lab-start.yaml"
kubectl -n starfleet rollout status deployment/telemetry-writer --timeout=180s
kubectl -n starfleet wait --for=condition=Ready pod/retired-holder --timeout=180s
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/telemetry --timeout=120s
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/retired-data --timeout=120s

# Remember the identity of the claim telemetry, so the grader can tell a resize
# from a delete and recreate.
claim_uid="$(kubectl -n starfleet get pvc telemetry -o jsonpath='{.metadata.uid}')"
kubectl -n starfleet create configmap lab-seed --from-literal=claim-uid="$claim_uid"

kubectl -n starfleet delete pvc retired-data --wait=false
echo "[lab] Ready."
