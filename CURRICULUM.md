# Curriculum Coverage

Exam: Certified Kubernetes Administrator (CKA). Domain: Storage (10%).

The [official objectives](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) were verified on 2026-10-11. Teaching structure is original; it does not add official exam requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Implement storage classes and dynamic volume provisioning | 3 + capstone |
| 020 | Configure volume types, access modes and reclaim policies | 4 + capstone |
| 030 | Manage persistent volumes and persistent volume claims | 4 + capstone |

| Section / module | Module | Teaching lessons |
| --- | --- | --- |
| 010 / 01 | Storage Classes And Provisioning Decisions | Provisioning, Classes And Drivers |
| 020 / 01 | Volume Lifetime, Access And Reclaim | Storage Lifecycles And Claims; Access Modes And Data Presentation; Reclaim Policies And Recovery |
| 030 / 01 | Persistent Object Binding And Administration | Binding, Expansion And Administrative Storage Decisions |
| 010 / 02 | Configure StorageClass Fields And The Default Class | StorageClass Fields And What They Control; The Default StorageClass And Claim Class Selection |
| 010 / 03 | Diagnose Pending Claims And Provisioning Failures | Reading A Pending Claim; Repairing A Pending Claim |
| 020 / 02 | Choose Ephemeral And Projected Volume Types | Scratch Space And Node Paths; Configuration, Secrets And Projected Volumes |
| 020 / 03 | Enforce Access Modes With ReadWriteOncePod | Volume Modes And Access Modes; Single-Pod Claims And Read-Only Mounts |
| 020 / 04 | Release And Reuse Retained Volumes | Reclaim Policy And Claim Deletion; Released Volumes And Rebinding |
| 030 / 02 | Resize A Persistent Volume Claim | Grow A Claim Through Its StorageClass; When A Resize Is Refused Or Does Not Grow |
| 030 / 03 | Control Which Volume A Claim Binds | How A Claim Finds Its Volume; Node Affinity, Mount Options And Pending Claims |
| 030 / 04 | Mount Claims In Workloads And Protect Them | Mount Claims In Pods, Deployments And StatefulSets; Storage Object In Use Protection |

The module goals and adaptation sources are recorded in AUTHORING.yaml. Every official objective is covered. Each section starts with an introduction, and each module ends with a summary. YAML banks follow the relevant summary and remain separate from the Markdown manifest.

This draft includes developed readings, private playgrounds and independent graded labs. Static and offline checks pass; live execution remains pending. ATP005 publication remains draft.

## Hands-On Coverage

This course has 3 ungraded module playgrounds and 4 draft independent labs. Tasks and solutions are registered around each lab immediately after its teaching reading. Static configuration, shell/Python/YAML, parser, lifecycle and offline grader checks pass. Live execution remains pending because the session cannot access Podman; installed CLI configuration validation is separately blocked by its maintenance lock.

| Module | Labs in teaching order |
| --- | --- |
| 010/01 | Provision Through A Delayed-Binding StorageClass |
| 020/01 | Preserve Claim Data Across Pod Replacement |
| 020/01 | Retain A Bound Volume Safely |
| 030/01 | Bind A Claim To An Existing Volume |

## Coverage Audit

Audited against the official CKA Storage objectives. Gaps found and closed: StorageClass fields and default class selection; diagnosing Pending claims; ephemeral, hostPath, ConfigMap, Secret and projected volume types; volume modes and ReadWriteOncePod; reclaim, Released volumes and rebinding; PVC expansion; selector, volumeName and nodeAffinity binding; StatefulSet claim templates; storage object in use protection. Raw block volumes are covered in reading only, because the kind default provisioner supports filesystem volumes only. Added labs, capstones and playgrounds are UNTESTED.
