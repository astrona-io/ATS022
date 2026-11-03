---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Configure volume types, access modes and reclaim policies

A report saved inside one container disappears when that container is replaced. A file in `emptyDir` can survive a container restart but not Pod removal. A persistent claim supplies a different storage lifetime, subject to its backend and deletion policy.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Compare ephemeral and persistent volume lifetimes.
- Interpret access and volume modes.
- Explain application concurrency limits.
- Predict reclaim and recovery consequences.

## Modules

- Module 01 (existing): the original reading and lab.
- Module 02: Choose Ephemeral And Projected Volume Types. Parts: Scratch Space And Node Paths; Configuration, Secrets And Projected Volumes. Lab: Combine Memory-Backed And Projected Volumes.
- Module 03: Enforce Access Modes With ReadWriteOncePod. Parts: Volume Modes And Access Modes; Single-Pod Claims And Read-Only Mounts. Lab: Enforce A Single-Pod Claim And A Read-Only Mount.
- Module 04: Release And Reuse Retained Volumes. Parts: Reclaim Policy And Claim Deletion; Released Volumes And Rebinding. Lab: Reuse A Released Volume And Keep A Dynamic Volume.
- Capstone: Volume Types, Access Modes And Reclaim Handling.
- Knowledge check: `quiz.yaml`.
