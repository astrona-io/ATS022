---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Implement storage classes and dynamic volume provisioning

A claim requests storage, but no volume appears until the selected provisioner can fulfill it. StorageClass parameters, topology and the consumer's node choice can all participate. A Pending claim therefore needs provisioning evidence rather than repeated application restarts.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain class selection and dynamic provisioning.
- Distinguish expected delayed binding from failure.
- Evaluate topology, expansion and driver capabilities.
- Identify retention consequences before administrative changes.

## Modules

- Module 01 (existing): the original reading and lab.
- Module 02: Configure StorageClass Fields And The Default Class. Parts: StorageClass Fields And What They Control; The Default StorageClass And Claim Class Selection. Lab: Create A Retaining Default StorageClass.
- Module 03: Diagnose Pending Claims And Provisioning Failures. Parts: Reading A Pending Claim; Repairing A Pending Claim. Lab: Repair Pending Claims.
- Capstone: StorageClasses And Dynamic Provisioning.
- Knowledge check: `quiz.yaml`.
