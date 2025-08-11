FROM quay.io/curl/curl:8.15.0 AS deps

USER root

ARG YQ_VERSION=v4.47.1
ARG YQ_BINARY=yq_linux_amd64
ARG JB_VERSION=v0.6.0
ARG JB_BINARY=jb-linux-amd64
ARG GO_JSONNET_VERSION=v0.21.0
ARG GO_JSONNET_ARCHIVE=go-jsonnet_Linux_x86_64.tar.gz

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}" -o /yq
RUN curl -L "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JB_VERSION}/${JB_BINARY}" -o /jb
RUN curl -L "https://github.com/google/go-jsonnet/releases/download/${GO_JSONNET_VERSION}/${GO_JSONNET_ARCHIVE}" -o /jsonnet-archive
RUN tar -xvf /jsonnet-archive -C /

FROM docker.io/alpine/git:2.49.1

COPY --chmod=755 --from=deps /yq /usr/bin/yq
COPY --chmod=755 --from=deps /jb /usr/bin/jb
COPY --chmod=755 --from=deps /jsonnet /usr/bin/jsonnet
COPY --chmod=755 --from=deps /jsonnet-deps /usr/bin/jsonnet-deps
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
