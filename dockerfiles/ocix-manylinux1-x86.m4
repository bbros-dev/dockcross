FROM quay.io/pypa/manylinux1_i686:latest
ARG OCIX_IMAGE
ARG OCIX_NAME
ARG OCIX_ORG
ARG OCIX_VERSION

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

include(shared/manylinux.m4)

include(shared/docker.m4)

ENV CROSS_TRIPLE i686-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-2/root/usr/bin
ENV AS=${CROSS_ROOT}/as \
    AR=${CROSS_ROOT}/ar \
    CC=${CROSS_ROOT}/gcc \
    CPP=${CROSS_ROOT}/cpp \
    CXX=${CROSS_ROOT}/g++ \
    LD=${CROSS_ROOT}/ld \
    FC=${CROSS_ROOT}/gfortran

COPY linux-x86/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY ocix-manylinux1-x86/Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

COPY ocix-linux-x86/linux32-entrypoint.sh /ocix/
ENTRYPOINT ["/ocix/linux32-entrypoint.sh"]

include(shared/label.m4)
