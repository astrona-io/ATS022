# Storage (ATS022)

Certified Kubernetes Administrator (CKA): Storage, worth 10% of the official curriculum. This course belongs to ATP005.

Developed reading lessons explain configuration, component responsibility, worked reasoning and failure limits. Every section has an introduction, and every module ends with a summary. Reusable YAML knowledge checks are indexed separately. Technical content remains draft.

## Course Outline

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

## Author Review

The [curriculum map](CURRICULUM.md) records objective coverage. [Sources](SOURCES.md) support author review, and [assessment documentation](ASSESSMENTS.md) describes the reusable YAML contract. Guided practice and independent graded labs use private environments. Live verification remains pending.

## Hands-On Coverage

This course has 11 ungraded module playgrounds, 11 module labs and 3 section capstones. The original 3 playgrounds and 4 labs are listed first; every lab, capstone and playground added later is UNTESTED: it passed `astrona validate -c`, `bash -n` and YAML parsing only. Tasks and solutions are registered around each lab immediately after its teaching reading. Static configuration, shell/Python/YAML, parser, lifecycle and offline grader checks pass. Live execution remains pending because the session cannot access Podman; installed CLI configuration validation is separately blocked by its maintenance lock.

| Module | Labs in teaching order |
| --- | --- |
| 010/01 | Provision Through A Delayed-Binding StorageClass |
| 020/01 | Preserve Claim Data Across Pod Replacement |
| 020/01 | Retain A Bound Volume Safely |
| 030/01 | Bind A Claim To An Existing Volume |
| 010/02 | Create A Retaining Default StorageClass (UNTESTED) |
| 010/03 | Repair Pending Claims (UNTESTED) |
| 020/02 | Combine Memory-Backed And Projected Volumes (UNTESTED) |
| 020/03 | Enforce A Single-Pod Claim And A Read-Only Mount (UNTESTED) |
| 020/04 | Reuse A Released Volume And Keep A Dynamic Volume (UNTESTED) |
| 030/02 | Resize A Persistent Volume Claim (UNTESTED) |
| 030/03 | Control Which Volume A Claim Binds (UNTESTED) |
| 030/04 | Mount Claims In Workloads And Protect Them (UNTESTED) |
| 010 capstone | StorageClasses And Dynamic Provisioning Capstone (UNTESTED) |
| 020 capstone | Volume Types, Access Modes And Reclaim Handling Capstone (UNTESTED) |
| 030 capstone | Persistent Volumes And Claims Capstone (UNTESTED) |

## Quizzes

Each section has a `quiz.yaml` knowledge check (10 single-choice questions, pass score 70) and `sections/final-domain-quiz.yaml` closes the course (15 questions). The older `questions.yaml` banks and `assessments/` files stay as author practice material.
