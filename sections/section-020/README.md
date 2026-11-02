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
