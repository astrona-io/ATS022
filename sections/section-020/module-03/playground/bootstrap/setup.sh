#!/usr/bin/env bash
# Playground starting state for module 020/03: a namespace and two static
# PersistentVolumes (ReadWriteOncePod and ReadOnlyMany). No claims yet.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/start.yaml"
echo "[playground] Ready."
