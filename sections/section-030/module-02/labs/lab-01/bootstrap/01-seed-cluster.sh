#!/usr/bin/env bash
# Starting state for the claim resize lab. Environment only: it creates the
# class without expansion, the 100Mi claim and the Deployment that uses it.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/bootstrap/manifests/lab-start.yaml"
kubectl -n starfleet rollout status deployment/data-writer --timeout=180s
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/data --timeout=120s

# Remember the identity of the claim, so the grader can tell a resize from a
# delete and recreate.
claim_uid="$(kubectl -n starfleet get pvc data -o jsonpath='{.metadata.uid}')"
kubectl -n starfleet create configmap lab-seed --from-literal=claim-uid="$claim_uid"
echo "[lab] Ready."
