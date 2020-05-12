FROM quay.io/pypa/manylinux2010_i686:2020-04-06-694ff3c

WORKDIR /work

include(shared/environment.m4)

include(shared/manylinux.m4)

# Test suite test/run.py report error:
# /opt/rh/devtoolset-8/root/usr/bin/gcc
# is not a full path to an existing compiler tool.
RUN ln -s /opt/rh/devtoolset-8/root/usr/bin/gcc /usr/bin/cc && \
    ln -s /opt/rh/devtoolset-8/root/usr/bin/g++ /usr/bin/c++

include(shared/docker.m4)

# Override yum to work around the problem with newly built libcurl.so.4
# https://access.redhat.com/solutions/641093
RUN echo $'#!/bin/bash\n\
LD_PRELOAD=/usr/lib/libcurl.so.4 /usr/bin/yum "$@"' > /usr/local/bin/yum && chmod a+x /usr/local/bin/yum

ENV CROSS_TRIPLE i686-linux-gnu
ENV CROSS_ROOT /opt/rh/devtoolset-7/root/usr/bin
# Following mimic ocix-linux-x86.sh
#RUN cd ${CROSS_ROOT}/bin && \
#  ln -s /usr/bin/x86_64-linux-gnu-gcc && \
#  ln -s /usr/bin/x86_64-linux-gnu-g++ && \
#  ln -s /usr/bin/x86_64-linux-gnu-as && \
#  ln -s ${CROSS_TRIPLE}.sh ${CROSS_TRIPLE}-gcc && \
#  ln -s ${CROSS_TRIPLE}.sh ${CROSS_TRIPLE}-g++ && \
#  ln -s ${CROSS_TRIPLE}-as.sh ${CROSS_TRIPLE}-as && \
#  ln -s /usr/bin/x86_64-linux-gnu-ar ${CROSS_TRIPLE}-ar && \
#  ln -s ${CROSS_TRIPLE}-noop.sh ${CROSS_TRIPLE}-noop
#ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
#    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
#    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
#    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++
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

COPY scripts/linux32-entrypoint.sh /ocix/
ENTRYPOINT ["/ocix/linux32-entrypoint.sh"]

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
