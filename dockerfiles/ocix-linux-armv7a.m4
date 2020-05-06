include(shared/base.m4)

# This is for 32-bit ARMv7 Linux

include(shared/aptitude-env.m4)

# The cross-compiling emulator.
# For Debian ARM details see:
# https://wiki.debian.org/ArmPorts
RUN dpkg --add-architecture armhf && \
    aptitude update && \
    aptitude -f --no-gui -q -y --without-recommends install\
              crossbuild-essential-armhf \
              libtool-bin:armhf \
              qemu-user:armhf \
              qemu-user-static:armhf \
              texinfo:armhf \
              unzip:armhf && \
    aptitude -f --no-gui -q -y clean

include(shared/crosstool.m4)

# The CROSS_TRIPLE is a configured alias of the "aarch64-unknown-linux-gnueabi" target.
#ENV CROSS_TRIPLE armv7-unknown-linux-gnueabi
ENV CROSS_TRIPLE arm-cortexa8_neon-linux-gnueabihf
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

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

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
