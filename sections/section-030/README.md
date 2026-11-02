---
draft: true
exam_objectives:
- Manage persistent volumes and persistent volume claims
---
# Manage persistent volumes and persistent volume claims

A claim asks for a larger filesystem, but its provisioner does not support expansion. Editing requested capacity cannot create a missing backend capability. Storage administration starts with the contract that the provisioner and volume actually support.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain PV and PVC scope and matching.
- Distinguish static binding from dynamic allocation.
- Diagnose provisioning, attachment and mount stages.
- Evaluate expansion and safe retained-volume reuse.
