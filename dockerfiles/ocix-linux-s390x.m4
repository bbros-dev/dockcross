include(shared/base.m4)
# This is for 64-bit S390X Linux machine

include(shared/aptitude-env.m4)

# The cross-compiling emulator
RUN dpkg --add-architecture s390x && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --with-recommends install \
              crossbuild-essential-s390x && \
    aptitude -f --no-gui -q -y clean

include(shared/crosstool.m4)

# The CROSS_TRIPLE is a configured alias of the "s390x-ibm-linux-gnu" target.
ENV CROSS_TRIPLE s390x-ibm-linux-gnu

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
ENV ARCH s390

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
