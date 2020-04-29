include(shared/base.m4)

# This is for 64-bit ARM Linux machine

include(shared/crosstool.m4)

# The cross-compiling emulator
RUN dpkg --add-architecture arm64 && \
    aptitude -q -f -y --no-gui --without-recommends -u install \
                      crossbuild-essential-arm64:arm64 \
                      libelf-dev:arm64 \
                      qemu-user:arm64 \
                      qemu-user-static:arm64 \
                      unzip:arm64 && \
    aptitude --no-gui -f -q -y clean

# The CROSS_TRIPLE is a configured alias of the "aarch64-unknown-linux-gnueabi" target.
ENV CROSS_TRIPLE aarch64-unknown-linux-gnueabi

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

ENV PKG_CONFIG_PATH /usr/lib/aarch64-linux-gnu/pkgconfig

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH arm64

include(shared/label.m4)
