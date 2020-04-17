FROM quay.io/pypa/manylinux1_x86_64:2020-04-06-3cde635

ARG OCIX_ORG=dockcross
ARG OCIX_VERSION

ENV DEFAULT_OCIX_IMAGE ${OCIX_ORG}/manylinux1-x64:${OCIX_VERSION}

#include "common.manylinux"

#include "common.docker"

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-2/root/usr/bin
ENV AS=${CROSS_ROOT}/as \
    AR=${CROSS_ROOT}/ar \
    CC=${CROSS_ROOT}/gcc \
    CPP=${CROSS_ROOT}/cpp \
    CXX=${CROSS_ROOT}/g++ \
    LD=${CROSS_ROOT}/ld \
    FC=${CROSS_ROOT}/gfortran

COPY linux-x64/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY manylinux1-x64/Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

# OCI container annotations are as defined at  https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG IMAGE=${OCIX_ORG}/ocix-manylinux1-x64
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
