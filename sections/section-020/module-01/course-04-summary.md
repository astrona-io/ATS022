---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Summary

Volume types and access modes describe different lifetime and use relationships. Shared access is not a complete application coordination mechanism, and container restart is not the same event as Pod replacement.

Reclaim policy and backend retention determine deletion consequences. Persistent availability still needs backup, recovery and safe reassignment design when data must survive corruption, loss or tenant changes.

You can now separate workload cleanup from storage deletion and recovery. A retention decision preserves an opportunity to recover data, while backups and a tested restoration process establish how that recovery can succeed.
