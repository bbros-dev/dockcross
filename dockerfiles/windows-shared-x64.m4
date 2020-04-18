# NOTE: Arguments are reset to empty after the FROM statement.
#       Unless they are not.
#       This funkyness is from Docker world: 
#       https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#       https://docs.docker.com/engine/reference/builder/#scope
ARG OCIX_ORG=dockcross
ARG OCIX_VERSION
FROM ${OCIX_ORG}/ocix-base:${OCIX_VERSION}
ARG OCIX_ORG
ARG OCIX_VERSION

ENV WINEARCH win64
ARG MXE_TARGET_ARCH=x86_64
ARG MXE_TARGET_THREAD=
ARG MXE_TARGET_LINK=shared

#include "common.windows"

# OCI container annotations are as defined at  https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG IMAGE=${OCIX_ORG}/windows-shared-x64
ARG VCS_REF
ARG VCS_URL
ARG OCIX_URL="https://github.com/dockcross/dockcross/blob/master/README.rst"
LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.description=$IMAGE \
      org.opencontainers.image.documentation=$OCIX_URL \
      org.opencontainers.image.licenses="SPDX-License-Identifier: MIT" \
      org.opencontainers.image.ref.name=$IMAGE \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source=$VCS_URL \
      org.opencontainers.image.title=$IMAGE \
      org.opencontainers.image.url=$OCIX_URL \
      org.opencontainers.image.vendor=$OCIX_ORG \
      org.opencontainers.image.version=$OCIX_VERSION
ENV DEFAULT_OCIX_IMAGE ${IMAGE}:${OCIX_VERSION}
