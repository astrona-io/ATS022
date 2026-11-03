#!/usr/bin/env bash
# Starting state for the section 010 capstone. Environment only: the claim
# probe-data names a class that does not exist, and the probe Deployment
# cannot start. The faults stay in place. The Deployment UID is saved so the
# grader can tell if the learner deleted and recreated it.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl wait --for=condition=Ready node --all --timeout=180s
uid="$(kubectl -n starfleet get deployment probe -o jsonpath='{.metadata.uid}')"
kubectl -n kube-system create configmap capstone-baseline --from-literal=probeUid="$uid" --dry-run=client -o yaml | kubectl apply -f -
echo "[lab] Ready."
