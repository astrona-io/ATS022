---
draft: true
exam_objectives:
- Configure volume types, access modes and reclaim policies
---
# Access Modes And Data Presentation

Two Pods on the same node may use a ReadWriteOnce volume, even though its name sounds like a single-Pod limit. Access mode describes a storage access constraint, not an application lock. Separate node access from concurrent writers.

## Learning objectives

- Compare ephemeral and persistent volume lifetimes.
- Interpret access and volume modes.
- Explain application concurrency limits.

## Before you start

This chapter is standalone reading material; no running cluster or installed tools are required. A Pod is the Kubernetes unit for running one or more containers, and a namespace groups namespaced objects. Treat the worked configurations as teaching examples rather than recorded observations from a provisioned environment.

## Responsible components and behavior

Two `probe` Pods need access to stored reports. Access modes describe supported mounting arrangements, not the application's transaction rules. ReadWriteOnce allows read-write mounting by one node, which can include several Pods on that node. It does not universally mean one Pod.

ReadOnlyMany supports read-only mounting by many nodes. ReadWriteMany supports read-write mounting by many nodes where the storage implementation provides it. ReadWriteOncePod restricts a supported volume to a single Pod and requires compatible Container Storage Interface (CSI) support. Not every driver supports every access mode.

Access modes do not make simultaneous application writes consistent. A shared filesystem can be mounted successfully while two writers corrupt their own application data. Applications need locking, coordination or a data service designed for concurrent access. Many replicas are not a reason to assume all their storage must support shared writes.

Volume mode controls how the storage is presented. Filesystem mode exposes a mounted filesystem. Block mode exposes a raw block device for applications that can use it. Choosing block mode does not automatically format the device or make an ordinary file-based application compatible with it.

The storage's topology and failure properties also affect the decision. A volume available on one node or zone may constrain placement. A supported access mode describes the attachment contract, while availability describes whether the storage remains reachable under failures.

Choose from the actual access pattern: one application member with its own data, shared read-only artifacts, or coordinated multi-writer storage. Then check driver capabilities and the application's data model. A storage claim cannot create capabilities that the backend lacks.

## Choosing An Access Pattern For Replicas

A database member may need exclusive access to its own storage, while a document-serving application may allow many readers of shared files. A report system with several writers needs a backend and application protocol that safely coordinate writes. These are different contracts even if all use persistent claims.

ReadWriteOnce permits read-write mounting by one node under the supported arrangement. Several Pods on that same node can therefore be possible consumers. ReadWriteOncePod expresses a single-Pod restriction with compatible CSI support. The stronger mode is relevant when the application requires a single consumer boundary rather than merely a single node.

ReadWriteMany describes a backend-supported multi-node write access pattern. It does not supply database transactions, file-level locks or safe application merge behavior by itself. Two writers can successfully mount a shared volume and still overwrite each other's records. Access success and data correctness are separate evidence.

## Filesystem Versus Raw Device

Filesystem mode presents mounted directories and files. Block mode presents a raw device that the application must know how to use. A file-oriented web application does not automatically become block-aware when its claim changes mode. The backend and driver must support the selected presentation too.

Capacity, performance and availability also differ from access mode. A share supporting many writers can still have insufficient throughput. A volume allowing one node can be attachable in a restricted zone. A large volume can retain data but still depend on one failure-prone device.

A complete storage decision states the consumers, concurrency model, presentation, topology and recovery requirements. Then compare those needs with the supported class and driver behavior. This avoids treating one access-mode abbreviation as a full specification of safe application storage.

## Work through the decision

ReadWriteOnce permits read-write mounting by one node under the backend's supported semantics. It is not a promise that only one process or Pod writes. ReadWriteOncePod provides the stricter single-Pod access contract where the supported CSI driver and cluster features provide it. ReadWriteMany describes supported read-write access by multiple nodes, not safety for arbitrary shared-file application logic.

Volume mode addresses another question. Filesystem mode exposes files through a mounted filesystem; Block mode exposes a raw block device through the supported device mapping. An application expecting directory paths cannot use a block presentation as though it already had files. Inspect mode and backend capability alongside access modes before changing the application.

```mermaid
flowchart TB
    C["Claim access mode"] --> B["Backend capability"]
    C --> N["Eligible mounting scope"]
    V["Volume mode"] --> F["Filesystem or block presentation"]
    N --> A["Application access"]
    F --> A
    B --> A
```

Mounting scope and data presentation constrain access, while concurrency correctness remains an application responsibility.

You can now distinguish mounting permission from safe concurrent use. A valid access mode still requires compatible backend support and an application that handles shared data correctly.

## Common pitfalls

> [!WARNING]
> ReadWriteOnce means one node, not necessarily one Pod. Successful shared mounting does not guarantee safe concurrent application writes.
