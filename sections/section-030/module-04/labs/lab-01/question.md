# Question

Solve this question on: `terminal`

The `beacon` crew in `starfleet` is moving its log service to a StatefulSet. The headless Service `crew-log` already exists in `starfleet`.

1. Create a StatefulSet `crew-log` in `starfleet` with `serviceName: crew-log` and 2 replicas. Its Pods run one container with the image `docker.io/library/busybox:1.37.0` that writes its own host name to `/data/owner` and then sleeps. Each replica must have its own claim from a `volumeClaimTemplates` entry named `data`: `ReadWriteOnce`, `50Mi`, class `standard`, mounted at `/data`.

2. The old claim `old-claim` in `starfleet` was deleted, but it still exists with the status Terminating. Release it so that it is removed. Do not patch its finalizers.

`kubectl` already points at the cluster as the cluster administrator.
