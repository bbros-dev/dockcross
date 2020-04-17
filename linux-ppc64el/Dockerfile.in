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

ENV CROSS_TRIPLE powerpc64el-linux-gnu

COPY sources.list /etc/apt/sources.list
RUN dpkg --add-architecture ppc64el && \
    apt-get update && \
    apt-get install --no-install-recommends --yes aptitude && \
    aptitude update  --no-gui -f -q -y && \
    aptitude install -q -f -y --no-gui --without-recommends \
                      crossbuild-essential-ppc64el:ppc64el \
                      libbz2-dev:ppc64el \
                      libelf-dev:ppc64el \
                      libexpat1-dev:ppc64el \
                      libglib2.0-dev:ppc64el \
                      libpixman-1-dev:ppc64el \
                      libssl-dev:ppc64el \
                      ncurses-dev:ppc64el \
                      python-dev:ppc64el \
                      zlib1g-dev:ppc64el

#include "common.crosstool"

WORKDIR /usr/src

RUN curl -L http://wiki.qemu-project.org/download/qemu-2.6.0.tar.bz2 | tar xj && \
  cd qemu-2.6.0 && \
  ./configure --target-list=ppc64le-linux-user,ppc64-softmmu --prefix=/usr && \
  make -j$(nproc) && \
  make install && \
  cd .. && rm -rf qemu-2.6.0

ENV CROSS_ROOT ${XCC_PREFIX}/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld \
    FC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gfortran

ENV QEMU_LD_PREFIX "${CROSS_ROOT}/${CROSS_TRIPLE}/sysroot"
ENV QEMU_SET_ENV "LD_LIBRARY_PATH=${CROSS_ROOT}/lib:${QEMU_LD_PREFIX}"

WORKDIR /work

COPY Toolchain.cmake /usr/lib/${CROSS_TRIPLE}/
ENV CMAKE_TOOLCHAIN_FILE /usr/lib/${CROSS_TRIPLE}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/powerpc64el-linux-gnu/pkgconfig

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH powerpc

# OCI container annotations are as defined at  https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG IMAGE=${OCIX_ORG}/ocix-linux-ppc64el
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
