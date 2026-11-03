# Overview: Ephemeral And Projected Volume Types

This is a playground, not a lab. It starts a single-node kind cluster and waits. There is no task, no `astrona submit` and no pass or fail. Create objects, break them, run `astrona destroy`, start over.

## What is in the environment

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | ConfigMap `scout-settings` | Keys `greeting` (`hello`) and `level` (`info`) |
| `starfleet` | Secret `scout-token` | Key `token` |
| `starfleet` | Pod `shuttle` | An idle busybox Pod |

`kubectl` already points at the cluster as the cluster administrator.

## Practice ideas

- Write a Pod with two containers that share one `emptyDir`. Write a file in the first container and read it in the second. Delete the Pod and create it again to see the file disappear.
- Set `medium: Memory` and a `sizeLimit`, and read the mount type with `df` inside the container.
- Mount `scout-settings` as a volume with `items` that rename one key. Edit the ConfigMap, wait, and read the file again. Repeat with a `subPath` mount and compare.
- Combine the ConfigMap and the Secret in one `projected` volume and set the file mode of the token to `0400`. Read it with `stat -L -c %a`.
- Point a volume at a ConfigMap that does not exist, first with `optional: false` and then with `optional: true`.
