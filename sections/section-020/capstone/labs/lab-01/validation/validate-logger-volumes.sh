#!/usr/bin/env bash
# Check: probe-logger is Ready, shares a memory emptyDir of 32Mi, and reporter
# reads a read-only projected volume with the token at mode 0400.
set -uo pipefail
NS=starfleet
POD=probe-logger
ready="$(kubectl -n $NS get pod $POD -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
if [ "$ready" != "True" ]; then
  echo "FAIL: pod $POD in $NS is not Ready"
  exit 1
fi
vol="$(kubectl -n $NS get pod $POD -o jsonpath='{range .spec.volumes[?(@.emptyDir)]}{.name}{"|"}{.emptyDir.medium}{"|"}{.emptyDir.sizeLimit}{"\n"}{end}' 2>/dev/null | head -n1)"
name="${vol%%|*}"
rest="${vol#*|}"
medium="${rest%%|*}"
limit="${rest#*|}"
if [ -z "$name" ] || [ "$medium" != "Memory" ] || [ "$limit" != "32Mi" ]; then
  echo "FAIL: pod $POD needs an emptyDir with medium Memory and sizeLimit 32Mi (found '$vol')"
  exit 1
fi
for container in collector reporter; do
  mounted="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"$container\")].volumeMounts[?(@.name==\"$name\")].mountPath}" 2>/dev/null)"
  if [ -z "$mounted" ]; then
    echo "FAIL: container $container does not mount the emptyDir volume"
    exit 1
  fi
done
marker="check-$$"
spool="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"collector\")].volumeMounts[?(@.name==\"$name\")].mountPath}")"
rspool="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reporter\")].volumeMounts[?(@.name==\"$name\")].mountPath}")"
kubectl -n $NS exec $POD -c collector -- sh -c "echo $marker > $spool/.check" >/dev/null 2>&1
got="$(kubectl -n $NS exec $POD -c reporter -- cat "$rspool/.check" 2>/dev/null)"
if [ "$got" != "$marker" ]; then
  echo "FAIL: a file written by collector is not readable by reporter"
  exit 1
fi
pname="$(kubectl -n $NS get pod $POD -o jsonpath='{.spec.volumes[?(@.projected)].name}' 2>/dev/null | awk '{print $1}')"
if [ -z "$pname" ]; then
  echo "FAIL: pod $POD has no projected volume"
  exit 1
fi
sources="$(kubectl -n $NS get pod $POD -o jsonpath='{range .spec.volumes[?(@.projected)]}{range .projected.sources[*]}{.configMap.name}{.secret.name}{","}{end}{end}' 2>/dev/null)"
case "$sources" in
  *probe-settings*probe-token*|*probe-token*probe-settings*) ;;
  *) echo "FAIL: the projected volume must combine probe-settings and probe-token (found '$sources')"; exit 1 ;;
esac
ro="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reporter\")].volumeMounts[?(@.name==\"$pname\")].readOnly}" 2>/dev/null)"
path="$(kubectl -n $NS get pod $POD -o jsonpath="{.spec.containers[?(@.name==\"reporter\")].volumeMounts[?(@.name==\"$pname\")].mountPath}" 2>/dev/null)"
if [ -z "$path" ] || [ "$ro" != "true" ]; then
  echo "FAIL: reporter must mount the projected volume with readOnly: true"
  exit 1
fi
mode="$(kubectl -n $NS exec $POD -c reporter -- stat -L -c '%a' "$path/token" 2>/dev/null)"
if [ "$mode" != "400" ]; then
  echo "FAIL: the token file has mode '$mode', expected 400"
  exit 1
fi
value="$(kubectl -n $NS exec $POD -c reporter -- cat "$path/mode" 2>/dev/null)"
if [ "$value" != "survey" ]; then
  echo "FAIL: reporter cannot read the key mode of probe-settings at $path/mode"
  exit 1
fi
echo "PASS: probe-logger shares a memory emptyDir and reads read-only projected settings"
