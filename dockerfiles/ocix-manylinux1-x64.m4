FROM quay.io/pypa/manylinux1_x86_64:2020-04-06-3cde635

WORKDIR /work

include(shared/environment.m4)

RUN curl https://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/r/re2c-0.13.5-1.el6.x86_64.rpm \
         --output re2c-0.13.5-1.el6.x86_64.rpm && \
    rpm -Uvh re2c-0.13.5-1.el6.x86_64.rpm

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

COPY scripts/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY Toolchain.cmake ${CROSS_ROOT}/../lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/../lib/Toolchain.cmake

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
