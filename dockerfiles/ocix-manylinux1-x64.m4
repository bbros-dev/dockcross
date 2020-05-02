FROM quay.io/pypa/manylinux1_x86_64:2020-04-06-3cde635

ARG OCIX_ORG
ARG OCIX_VERSION

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

include(shared/manylinux.m4)

include(shared/docker.m4)

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-2/root/usr/bin
ENV AS=${CROSS_ROOT}/as \
    AR=${CROSS_ROOT}/ar \
    CC=${CROSS_ROOT}/gcc \
    CPP=${CROSS_ROOT}/cpp \
    CXX=${CROSS_ROOT}/g++ \
    LD=${CROSS_ROOT}/ld \
    FC=${CROSS_ROOT}/gfortran

COPY ocix-linux-x64/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY ocix-manylinux1-x64/Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
