# syntax=docker/dockerfile:1.7
FROM rust:1.98-bookworm@sha256:c49256cbe5ea0188bc658a689500d70c41eb51f009a7a7be209caf60a944f3ec

ARG TASK_VERSION=3.53.1
ARG NEXTEST_VERSION=0.9.143
ARG NFPM_VERSION=2.46.3

# Match the bounded Linux contributor-test prerequisites without inheriting a host toolchain.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gawk git libnss-wrapper \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -fsSLO "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_amd64.tar.gz"; \
    curl -fsSLO "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_checksums.txt"; \
    grep " task_linux_amd64.tar.gz$" task_checksums.txt | sha256sum -c -; \
    tar -xzf task_linux_amd64.tar.gz -C /usr/local/bin task; \
    rm task_linux_amd64.tar.gz task_checksums.txt

RUN set -eux; \
    archive="cargo-nextest-${NEXTEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"; \
    checksum="cargo-nextest-${NEXTEST_VERSION}-x86_64-unknown-linux-gnu.sha256"; \
    base="https://github.com/nextest-rs/nextest/releases/download/cargo-nextest-${NEXTEST_VERSION}"; \
    curl -fsSLo "$archive" "$base/$archive"; \
    curl -fsSLo "$checksum" "$base/$checksum"; \
    sha256sum -c "$checksum"; \
    tar -xzf "$archive" -C /usr/local/bin cargo-nextest; \
    rm "$archive" "$checksum"

RUN set -eux; \
    archive="nfpm_${NFPM_VERSION}_Linux_x86_64.tar.gz"; \
    base="https://github.com/goreleaser/nfpm/releases/download/v${NFPM_VERSION}"; \
    curl -fsSLo "$archive" "$base/$archive"; \
    curl -fsSLo checksums.txt "$base/checksums.txt"; \
    grep " $archive$" checksums.txt | sha256sum -c -; \
    tar -xzf "$archive" -C /usr/local/bin nfpm; \
    rm "$archive" checksums.txt

RUN rustc --version \
    && cargo --version \
    && task --version \
    && cargo nextest --version \
    && nfpm --version \
    && test -r /usr/lib/x86_64-linux-gnu/libnss_wrapper.so
