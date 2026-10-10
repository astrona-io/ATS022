---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Summary

Volume types and access modes describe different lifetime and use relationships. Shared access is not a complete application coordination mechanism, and container restart is not the same event as Pod replacement.

Reclaim policy and backend retention determine deletion consequences. Persistent availability still needs backup, recovery and safe reassignment design when data must survive corruption, loss or tenant changes.
