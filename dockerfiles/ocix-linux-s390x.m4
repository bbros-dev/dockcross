include(shared/base.m4)
# This is for 64-bit S390X Linux machine

# The cross-compiling emulator
RUN dpkg --add-architecture s390x && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --without-recommends install \
              libelf-dev:s390x=0.176-1.1 \
              libtool-bin:s390x=2.4.6-9 \
              qemu-user:s390x=1:3.1+dfsg-8+deb10u3 \
              qemu-user-static:s390x=1:3.1+dfsg-8+deb10u3 \
              unzip:s390x=6.0-23+deb10u1 \
              zlib1g-dev:s390x && \
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

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
