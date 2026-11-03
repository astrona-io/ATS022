#!/usr/bin/env bash
# Check: Pod scout-relay is Ready and has the containers writer and reader.
set -uo pipefail
ready="$(kubectl -n starfleet get pod scout-relay -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
names="$(kubectl -n starfleet get pod scout-relay -o jsonpath='{.spec.containers[*].name}' 2>/dev/null)"
if [ "$ready" != "True" ]; then
  echo "FAIL: pod scout-relay in starfleet is not Ready"
  exit 1
fi
for want in writer reader; do
  case " $names " in
    *" $want "*) ;;
    *) echo "FAIL: pod scout-relay has no container named $want"; exit 1 ;;
  esac
done
echo "PASS: scout-relay is Ready with containers writer and reader"
