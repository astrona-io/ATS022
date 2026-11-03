#!/usr/bin/env bash
# Check: a projected volume combines scout-settings and scout-token, is mounted
# read-only in reader, and the token file has mode 0400.
set -uo pipefail
NS=starfleet
POD=scout-relay
sources="$(kubectl -n $NS get pod $POD -o jsonpath='{range .spec.volumes[?(@.projected)]}{.name}{"|"}{range .projected.sources[*]}{.configMap.name}{.secret.name}{","}{end}{"\n"}{end}' 2>/dev/null | head -n1)"
name="${sources%%|*}"
list="${sources#*|}"
if [ -z "$name" ]; then
  echo "FAIL: pod $POD has no projected volume"
  exit 1
fi
case "$list" in
  *scout-settings*scout-token*|*scout-token*scout-settings*) ;;
  *) echo "FAIL: the projected volume must combine the ConfigMap scout-settings and the Secret scout-token (found: $list)"; exit 1 ;;
esac
ro="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reader\")].volumeMounts[?(@.name==\"$name\")].readOnly}" 2>/dev/null)"
path="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reader\")].volumeMounts[?(@.name==\"$name\")].mountPath}" 2>/dev/null)"
if [ -z "$path" ]; then
  echo "FAIL: container reader does not mount the projected volume $name"
  exit 1
fi
if [ "$ro" != "true" ]; then
  echo "FAIL: container reader must mount the projected volume with readOnly: true"
  exit 1
fi
greeting="$(kubectl -n $NS exec $POD -c reader -- cat "$path/greeting" 2>/dev/null)"
if [ "$greeting" != "hello" ]; then
  echo "FAIL: reader cannot read the key greeting at $path/greeting (got '$greeting')"
  exit 1
fi
token="$(kubectl -n $NS exec $POD -c reader -- cat "$path/token" 2>/dev/null)"
if [ "$token" != "lab-token-7f3a" ]; then
  echo "FAIL: reader cannot read the key token at $path/token"
  exit 1
fi
mode="$(kubectl -n $NS exec $POD -c reader -- stat -L -c '%a' "$path/token" 2>/dev/null)"
if [ "$mode" != "400" ]; then
  echo "FAIL: the token file has mode '$mode', expected 400"
  exit 1
fi
echo "PASS: projected settings are mounted read-only and the token file has mode 400"
