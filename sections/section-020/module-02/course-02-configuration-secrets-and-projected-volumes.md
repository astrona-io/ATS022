---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Configuration, Secrets And Projected Volumes

An application reads its settings from files, and its credentials from other files. Kubernetes stores settings in a ConfigMap, credentials in a Secret, and facts about the Pod in the Pod object itself. A volume turns each of these objects into files in the container. This part covers the `configMap`, `secret`, `downwardAPI` and `projected` volume types and the rules that decide which files appear, with which permissions, and when they change.

## ConfigMap and Secret volumes

A ConfigMap is an API object that holds non-confidential key-value data. A Secret holds small confidential data such as a token. In a `configMap` or `secret` volume, each key becomes one file whose name is the key and whose content is the value.

Save this as `pod-settings.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: settings
  namespace: starfleet
spec:
  containers:
    - name: client
      image: docker.io/library/busybox:1.37.0
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: settings
          mountPath: /etc/scout
          readOnly: true
  volumes:
    - name: settings
      projected:
        defaultMode: 0444
        sources:
          - configMap:
              name: scout-settings
              items:
                - key: greeting
                  path: greeting.txt
          - secret:
              name: scout-token
              items:
                - key: token
                  path: credentials/token
                  mode: 0400
```

<!-- astrona:playground:renew -->

Apply it:

```sh
kubectl apply -f pod-settings.yaml
```

Then read the files and the mode of the token:

```sh
kubectl -n starfleet wait --for=condition=Ready pod/settings --timeout=120s
kubectl -n starfleet exec settings -- cat /etc/scout/greeting.txt
kubectl -n starfleet exec settings -- stat -L -c '%a' /etc/scout/credentials/token
```

The first command prints the value of the key `greeting` in `scout-settings`. The second prints `400`, the mode set by `mode: 0400` on that item.

## Fields that shape the files

The field `items` lists the keys to project. A key that is not listed does not appear. Each item has a `path`, the relative file name inside the volume (it can contain directories), and an optional `mode`. Without `items`, every key becomes a file under its own name.

The field `defaultMode` sets the file permissions for every file in the volume that has no `mode` of its own. The default is `0644`. In a manifest, write the value in octal with a leading zero, as `0400`. In JSON output the same value appears as decimal `256`.

The field `optional` decides what happens when the source object or a listed key does not exist. With `optional: false`, the default, the Pod stays in `ContainerCreating` and the kubelet reports the missing object as an event. With `optional: true`, the Pod starts and the files are absent.

The field `readOnly` on the volume mount is a property of the mount, not of the volume. ConfigMap, Secret, downward API and projected volumes are always mounted read-only by the kubelet in current Kubernetes versions, and setting `readOnly: true` makes the intent explicit in the manifest.

## downwardAPI

A `downwardAPI` volume exposes fields of the Pod itself as files. A `fieldRef` reads a Pod field such as `metadata.labels` or `metadata.name`. A `resourceFieldRef` reads a container's `requests` or `limits`, and needs a `containerName` when the volume is not in that container's own scope.

```yaml
  volumes:
    - name: podinfo
      downwardAPI:
        items:
          - path: labels
            fieldRef:
              fieldPath: metadata.labels
```

Environment variables can carry the same values, but a file is updated when labels change and an environment variable is not.

## projected volumes

A `projected` volume maps several sources into one directory. The supported sources are `configMap`, `secret`, `downwardAPI` and `serviceAccountToken`. Two sources may not write the same path. The earlier manifest used a projected volume so that settings and the token appear under one mount point instead of two.

## When files change

The kubelet keeps the files of a ConfigMap, Secret, downward API or projected volume in sync with the source objects. The kubelet writes the new content into a new hidden directory and then swaps a symbolic link (`..data`) to it, so a reader never sees a half-written file. The update is not instant. It arrives after the kubelet's next sync, which can take about a minute.

There are two exceptions. A container that mounts the volume with `subPath` never receives updates, because the bind mount points at the file that existed at start. A ConfigMap or Secret marked `immutable: true` never changes, and the kubelet stops watching it, which reduces load on the API server.

The application also has to re-read the file. A process that reads its settings once at start keeps the old values until it restarts.

You can now select a volume type for any directory that a Pod needs and predict how its content and permissions behave. None of these types keeps data after the Pod is gone, except `hostPath`, and only on one node.

## Common pitfalls

> [!WARNING]
> `mode: 0400` is octal. Writing `400` sets a different permission, because the number is read as decimal. A `subPath` mount does not update when the ConfigMap changes. A missing ConfigMap with `optional: false` keeps the Pod in `ContainerCreating`, so read its events before you look at the container.
