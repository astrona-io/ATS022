#!/usr/bin/env bash
# Check: exactly one default class, and it is training-retain.
set -uo pipefail

defaults="$(kubectl get storageclass -o jsonpath='{range .items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")]}{.metadata.name}{"\n"}{end}' 2>/dev/null || true)"

if [ "$defaults" = "training-retain" ]; then
  echo "PASS: training-retain is the only default class"
  exit 0
fi
echo "FAIL: default classes are: $(echo "$defaults" | tr '\n' ' ')"
exit 1
