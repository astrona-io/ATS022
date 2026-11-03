#!/usr/bin/env bash
# Check: a memory-backed emptyDir with a 64Mi limit, shared by both containers.
set -uo pipefail
NS=starfleet
POD=scout-relay
vol="$(kubectl -n $NS get pod $POD -o jsonpath='{range .spec.volumes[?(@.emptyDir)]}{.name}{"|"}{.emptyDir.medium}{"|"}{.emptyDir.sizeLimit}{"\n"}{end}' 2>/dev/null)"
name="$(printf '%s\n' "$vol" | head -n1 | cut -d'|' -f1)"
medium="$(printf '%s\n' "$vol" | head -n1 | cut -d'|' -f2)"
limit="$(printf '%s\n' "$vol" | head -n1 | cut -d'|' -f3)"
if [ -z "$name" ]; then
  echo "FAIL: pod $POD has no emptyDir volume"
  exit 1
fi
if [ "$medium" != "Memory" ]; then
  echo "FAIL: the emptyDir volume $name does not use medium Memory"
  exit 1
fi
if [ "$limit" != "64Mi" ]; then
  echo "FAIL: the emptyDir volume $name has sizeLimit '$limit', expected 64Mi"
  exit 1
fi
for container in writer reader; do
  mounted="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"$container\")].volumeMounts[?(@.name==\"$name\")].mountPath}" 2>/dev/null)"
  if [ -z "$mounted" ]; then
    echo "FAIL: container $container does not mount the emptyDir volume $name"
    exit 1
  fi
done
marker="check-$$"
path="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"writer\")].volumeMounts[?(@.name==\"$name\")].mountPath}")"
rpath="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reader\")].volumeMounts[?(@.name==\"$name\")].mountPath}")"
kubectl -n $NS exec $POD -c writer -- sh -c "echo $marker > $path/.check" >/dev/null 2>&1
got="$(kubectl -n $NS exec $POD -c reader -- cat "$rpath/.check" 2>/dev/null)"
if [ "$got" != "$marker" ]; then
  echo "FAIL: a file written by writer is not readable by reader"
  exit 1
fi
echo "PASS: both containers share a memory-backed emptyDir limited to 64Mi"
