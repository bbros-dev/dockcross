# Recent versions address yum functionality
FROM quay.io/pypa/manylinux2014_x86_64:2020-04-06-2fd435d

WORKDIR /work

include(shared/environment.m4)

# Test suite test/run.py report error:
# /opt/rh/devtoolset-8/root/usr/bin/gcc
# is not a full path to an existing compiler tool.
RUN ln -s /opt/rh/devtoolset-8/root/usr/bin/gcc /usr/bin/cc && \
    ln -s /opt/rh/devtoolset-8/root/usr/bin/g++ /usr/bin/c++ && \
    ln -s /opt/rh/devtoolset-8/root/usr/bin/gcc /usr/bin/gcc && \
    ln -s /opt/rh/devtoolset-8/root/usr/bin/g++ /usr/bin/g++

include(shared/manylinux.m4)

include(shared/docker.m4)

# Override yum to work around the problem with newly built libcurl.so.4
# https://access.redhat.com/solutions/641093
RUN echo $'#!/bin/bash\n\
LD_PRELOAD=/usr/lib64/libcurl.so.4 /usr/bin/yum "$@"' > /usr/local/bin/yum && \
    chmod a+x /usr/local/bin/yum

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-8/root/usr/bin
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
