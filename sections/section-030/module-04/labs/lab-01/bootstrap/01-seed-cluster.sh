#!/usr/bin/env bash
# Starting state for the claim protection lab. Environment only: it creates the
# headless Service, the claim old-claim and the Pod holder, and then deletes
# old-claim so that it waits in Terminating. It does not create the StatefulSet.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/bootstrap/manifests/lab-start.yaml"
kubectl -n starfleet wait --for=condition=Ready pod/holder --timeout=180s
kubectl -n starfleet wait --for=jsonpath='{.status.phase}'=Bound pvc/old-claim --timeout=120s
kubectl -n starfleet delete pvc old-claim --wait=false
echo "[lab] Ready."
