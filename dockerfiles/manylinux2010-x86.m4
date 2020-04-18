FROM quay.io/pypa/manylinux2010_i686:latest
ARG OCIX_ORG=dockcross
ARG OCIX_VERSION

ENV DEFAULT_OCIX_IMAGE ${OCIX_ORG}/manylinux2010-x86:${OCIX_VERSION}

include(shared/manylinux.m4)

include(shared/docker.m4)

# Override yum to work around the problem with newly built libcurl.so.4
# https://access.redhat.com/solutions/641093
RUN echo $'#!/bin/bash\n\
LD_PRELOAD=/usr/lib/libcurl.so.4 /usr/bin/yum "$@"' > /usr/local/bin/yum && chmod a+x /usr/local/bin/yum

ENV CROSS_TRIPLE i686-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-7/root/usr/bin
ENV AS=${CROSS_ROOT}/as \
    AR=${CROSS_ROOT}/ar \
    CC=${CROSS_ROOT}/gcc \
    CPP=${CROSS_ROOT}/cpp \
    CXX=${CROSS_ROOT}/g++ \
    LD=${CROSS_ROOT}/ld \
    FC=${CROSS_ROOT}/gfortran

COPY linux-x86/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY manylinux2010-x86/Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

COPY linux-x86/linux32-entrypoint.sh /ocix/
ENTRYPOINT ["/ocix/linux32-entrypoint.sh"]

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE ${IMAGE}:${OCIX_VERSION}
