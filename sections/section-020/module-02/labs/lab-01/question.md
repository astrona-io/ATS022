# Question

Solve this question on: `terminal`

The `scout` team in `starfleet` needs a relay Pod. The `writer` container hands messages to the `reader` container, and the `reader` reads the scout settings and token.

The namespace `starfleet` has the ConfigMap `scout-settings` (keys `greeting` and `level`) and the Secret `scout-token` (key `token`). Create a Pod `scout-relay` in `starfleet` with two containers, both using the image `docker.io/library/busybox:1.37.0` and the command `sleep 3600`:

1. The containers are named `writer` and `reader`. Both mount one `emptyDir` volume at `/shared`. The volume must be kept in memory (`medium: Memory`) and limited to `64Mi`.
2. A single `projected` volume combines the ConfigMap `scout-settings` and the Secret `scout-token`. Only `reader` mounts it, at `/etc/scout`, read-only. The file for the key `token` is named `token` and has the file mode `0400`. The ConfigMap keys appear under their own names.
3. The Pod must be Ready.

`kubectl` already points at the cluster as the cluster administrator.
