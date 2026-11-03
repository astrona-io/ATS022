---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Enforce Access Modes With ReadWriteOncePod

An access mode states how many nodes or Pods may use a volume at the same time, and whether they may write. The four modes look similar, but they are enforced by different components, and only one of them limits a volume to a single Pod. This module explains who enforces each mode, how the volume mode decides whether a Pod sees a directory or a raw device, and what a second Pod experiences when a single-Pod claim is already in use.

## Learning Goals

- Explain `ReadWriteOnce`, `ReadOnlyMany`, `ReadWriteMany` and `ReadWriteOncePod`, and name the component that enforces each.
- Choose `volumeMode: Filesystem` or `Block` and write the matching Pod fields.
- Predict what a second Pod does when it mounts a `ReadWriteOncePod` claim that is in use.
- Tell a read-only mount from a read-only claim reference.

## Before You Start

You need to know what a PersistentVolume (PV), a PersistentVolumeClaim (PVC) and a Pod are. The module playground has the namespace `starfleet` and two static PVs, `playground-single` and `playground-shared`.

## Reading Order

1. Volume Modes And Access Modes
2. Single-Pod Claims And Read-Only Mounts
3. Summary

<!-- astrona:playground -->
