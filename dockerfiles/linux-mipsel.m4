include(shared/base.m4)

# This is for ARMv5 "legacy" (mipsel) devices which do NOT support hard float
# VFP instructions (mipshf).

# From https://wiki.debian.org/CrossToolchains, installing for jessie
RUN echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/emdebian.list && \
    curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - && \
    sed -i 's/httpredir.debian.org/http.debian.net/' /etc/apt/sources.list && \
    dpkg --add-architecture mipsel && \ 
    aptitude update && \
    apt-get install --no-install-recommends --yes aptitude && \
    aptitude update  --no-gui -f -q -y && \
    aptitude install -q -f -y --no-gui --without-recommends \
                      crossbuild-essential-mipsel:mips64el \
                      libelf-dev:mips64el \
                      qemu-user:mips64el \
                      qemu-user-static:mips64el

ENV CROSS_TRIPLE mipsel-linux-gnu
ENV CROSS_ROOT /usr/bin
ENV AS=${CROSS_ROOT}/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/${CROSS_TRIPLE}-cpp-4.9 \
    CXX=${CROSS_ROOT}/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/${CROSS_TRIPLE}-ld \
    FC=${CROSS_ROOT}/${CROSS_TRIPLE}-gfortran

ENV QEMU_LD_PREFIX ${CROSS_ROOT}/libc
ENV QEMU_SET_ENV "LD_LIBRARY_PATH=${CROSS_ROOT}/lib:${CROSS_ROOT}/libc/lib/${CROSS_TRIPLE}/"

COPY Toolchain.cmake ${CROSS_ROOT}/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/Toolchain.cmake

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH mips

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
