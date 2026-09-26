#!/usr/bin/env bash
set -euo pipefail

# Ota preserves the host numeric UID/GID in containers. Debian's base image does
# not contain a matching passwd entry, so provide one only for this process tree.
runtime_dir="$(mktemp -d "${TMPDIR:-/tmp}/ota-nss-wrapper.XXXXXX")"
uid="$(id -u)"
gid="$(id -g)"

printf 'ota:x:%s:%s:Ota container user:%s:/usr/sbin/nologin\n' "$uid" "$gid" "${HOME:-/tmp}" \
  > "$runtime_dir/passwd"
printf 'ota:x:%s:\n' "$gid" > "$runtime_dir/group"

export NSS_WRAPPER_PASSWD="$runtime_dir/passwd"
export NSS_WRAPPER_GROUP="$runtime_dir/group"
export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnss_wrapper.so${LD_PRELOAD:+:$LD_PRELOAD}"

exec "$@"
