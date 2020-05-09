include(shared/base.m4)

# This is for ARMv5 "legacy" (armel) devices which do NOT support hard float
# VFP instructions (armhf).

include(shared/aptitude-env.m4)

# The cross-compiling emulator
RUN dpkg --add-architecture armel && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --with-recommends install \
              crossbuild-essential-armel && \
    aptitude -f --no-gui -q -y clean

include(shared/crosstool.m4)

# The CROSS_TRIPLE is a configured alias of the "aarch64-unknown-linux-gnueabi" target.
ENV CROSS_TRIPLE armv5-unknown-linux-gnueabi
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

COPY Toolchain.cmake ${CROSS_ROOT}/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/arm-linux-gnueabihf/

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH arm

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
