# syntax=docker/dockerfile:1.7
FROM rust:1.97-bookworm@sha256:0e2bcaef56d041a486784e54104a81aebe0da44bd03019bd70bc0401e42e4a97

ARG TASK_VERSION=3.53.1
ARG NEXTEST_VERSION=0.9.143
ARG NFPM_VERSION=2.46.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git nodejs \
    && rm -rf /var/lib/apt/lists/*

# Ota executes the ephemeral container as the GitHub runner UID. SSH tooling
# requires that UID to resolve through passwd rather than treating it as an
# anonymous process identity.
RUN groupadd --gid 1001 anodizer \
    && useradd --uid 1001 --gid 1001 --create-home --shell /bin/bash anodizer

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
    && node --version \
    && task --version \
    && cargo nextest --version \
    && nfpm --version
