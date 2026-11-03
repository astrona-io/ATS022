---
draft: true
exam_objectives:
- Implement storage classes and dynamic volume provisioning
---
# Summary

The phase Pending on a claim has four common causes, and the events on the claim and its Pod tell them apart. The PV controller writes that a class is not found. An ExternalProvisioning event with nothing after it means a class names a provisioner that no controller serves. A WaitForFirstConsumer event means no Pod uses the claim yet and is not a failure. A FailedScheduling event on the Pod means a placement rule, such as a node selector or an allowed topology, cannot be met.

A repair depends on which field is wrong. The storageClassName, access modes and volume name of a claim cannot be edited after creation, and the volumes of a Pod cannot either. The repair is to create the missing object, such as the class the claim names, or to delete the Pod and the claim and create them again with a valid class. A claim that a Pod uses stays in the phase Terminating until the Pod is gone, and a claim with a Delete reclaim policy takes its volume with it.

The provisioner is a Pod with its own logs. In kind it runs in the namespace local-path-storage. A class that names a provisioner with no running Pod has no logs to read, so the evidence is the missing events.

Key facts:

- Read describe on the claim first, then describe on the Pod.
- Pending under WaitForFirstConsumer with no Pod is expected.
- A wrong storageClassName means delete and create again, or create the missing class.

<!-- astrona:playground:destroy -->
