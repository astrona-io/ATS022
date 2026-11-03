#!/usr/bin/env bash
# Check: reader cannot write into the projected settings directory.
set -uo pipefail
NS=starfleet
POD=scout-relay
name="$(kubectl -n $NS get pod $POD -o jsonpath='{.spec.volumes[?(@.projected)].name}' 2>/dev/null | awk '{print $1}')"
path="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reader\")].volumeMounts[?(@.name==\"$name\")].mountPath}" 2>/dev/null)"
if [ -z "$name" ] || [ -z "$path" ]; then
  echo "FAIL: reader does not mount a projected volume"
  exit 1
fi
if kubectl -n $NS exec $POD -c reader -- sh -c "echo x > $path/new-file" >/dev/null 2>&1; then
  echo "FAIL: reader could write into $path"
  exit 1
fi
echo "PASS: reader cannot write into the projected settings directory"
