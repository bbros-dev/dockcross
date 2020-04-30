include(shared/base.m4)
# This is for 32-bit Big-Endian MIPS devices with hard floating point enabled

include(shared/crosstool.m4)

# The cross-compiling emulator
RUN dpkg --add-architecture mips && \
    aptitude  --no-gui -f -q -y update && \
    aptitude -f --no-gui -q -y --without-recommends install \
                      libelf-dev:mips \
                      qemu-user:mips \
                      qemu-user-static:mips
                      unzip:mips && \
      aptitude clean  --no-gui -f -q -y

# The CROSS_TRIPLE is a configured alias of the "mips-unknown-linux-gnu" target.
ENV CROSS_TRIPLE mips-unknown-linux-gnu

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

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH mips

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
