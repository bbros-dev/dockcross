include(shared/base.m4)
ENV CROSS_TRIPLE powerpc64el-linux-gnu

COPY sources.list /etc/apt/sources.list

RUN dpkg --add-architecture ppc64el && \
    aptitude -f --no-gui -q -y purge \
              libexpat1\
              perl-base \
              texinfo && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --without-recommends install \
              crossbuild-essential-ppc64el:ppc64el \
              libbz2-dev:ppc64el \
              libelf-dev:ppc64el \
              libexpat1-dev:ppc64el \
              libglib2.0-dev:ppc64el \
              libpixman-1-dev:ppc64el \
              libssl-dev:ppc64el \
              libtool-bin:ppc64el \
              ncurses-dev:ppc64el \
              texinfo:ppc64el=6.5.0.dfsg.1-4+b1 \
              zlib1g-dev:ppc64el \
              unzip:ppc64el && \
    aptitude -f --no-gui -q -y clean

include(shared/crosstool.m4)

WORKDIR /usr/src

RUN curl -L http://wiki.qemu-project.org/download/qemu-2.6.0.tar.bz2 | tar xj && \
  cd qemu-2.6.0 && \
  ./configure --target-list=ppc64le-linux-user,ppc64-softmmu --prefix=/usr && \
  make -j$(nproc) && \
  make install && \
  cd .. && rm -rf qemu-2.6.0

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

WORKDIR /work

COPY Toolchain.cmake /usr/lib/${CROSS_TRIPLE}/
ENV CMAKE_TOOLCHAIN_FILE /usr/lib/${CROSS_TRIPLE}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/powerpc64el-linux-gnu/pkgconfig

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH powerpc

include(shared/label.m4)
