#!/usr/bin/env bash
# Starting state for the access modes lab: a namespace and two static
# PersistentVolumes. The claims and Pods are the learner's task.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
echo "[lab] Ready."
