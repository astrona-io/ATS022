---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Summary

A volume declared in a Pod gives its containers a directory, and the volume type decides who owns the data, how long it lives and what fills it. The kubelet prepares the directory on the node and the container runtime mounts it into every container that names the volume.

An `emptyDir` volume starts empty and lives as long as the Pod stays on the node. It survives container restarts, not Pod replacement. Its `medium: Memory` option puts it on a `tmpfs` that counts against memory, and `sizeLimit` caps its size. A `hostPath` volume exposes a node path, keeps its data on that one node and gives the Pod access to the node, so it suits node agents and single-node practice clusters. A `subPath` mount exposes one directory of a volume and does not receive source updates.

ConfigMap, Secret, downward API and projected volumes turn API objects into files. `items` selects keys and names the files, `defaultMode` and per-item `mode` set permissions in octal, and `optional` decides whether a missing source blocks the Pod. The kubelet updates these files after a sync delay by swapping a symbolic link, except for `subPath` mounts and immutable objects. A projected volume combines several sources under one mount.

Key facts:

- `emptyDir` data is deleted with the Pod; `hostPath` data stays on the node.
- A memory-backed `emptyDir` uses memory; its `sizeLimit` sets the volume size.
- `0400` is octal; JSON shows it as `256`.
- A `subPath` mount of a ConfigMap or Secret never updates.

<!-- astrona:playground:destroy -->
