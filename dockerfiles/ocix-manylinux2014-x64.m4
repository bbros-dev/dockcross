# Recent versions address yum functionality
FROM quay.io/pypa/manylinux2014_x86_64:latest
ARG OCIX_ORG
ARG OCIX_VERSION

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

include(shared/manylinux.m4)

include(shared/docker.m4)

# Override yum to work around the problem with newly built libcurl.so.4
# https://access.redhat.com/solutions/641093
RUN echo $'#!/bin/bash\n\
LD_PRELOAD=/usr/lib64/libcurl.so.4 /usr/bin/yum "$@"' > /usr/local/bin/yum && chmod a+x /usr/local/bin/yum

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-8/root/usr/bin
ENV AS=${CROSS_ROOT}/as \
    AR=${CROSS_ROOT}/ar \
    CC=${CROSS_ROOT}/gcc \
    CPP=${CROSS_ROOT}/cpp \
    CXX=${CROSS_ROOT}/g++ \
    LD=${CROSS_ROOT}/ld \
    FC=${CROSS_ROOT}/gfortran

COPY linux-x64/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY manylinux2014-x64/Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
