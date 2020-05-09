include(shared/base.m4)

include(shared/aptitude-env.m4)

# gcc-multilib:i386 \
#                       g++-multilib:i386 \
#                       libc6:i386 \
#                       libelf-dev:i386 \
#                       libstdc++6:i386 \
#                       libbz2-dev:i386 \
#                       libexpat1-dev:i386 \
#                       ncurses-dev:i386 \
#                       unzip:i386
RUN dpkg --add-architecture i386 && \
    aptitude update  -f --no-gui -q -y&& \
    aptitude install -f --no-gui -q -y --with-recommends \
                      crossbuild-essential-i386 && \
    aptitude -f --no-gui -q -y clean

ENV CROSS_TRIPLE=i686-linux-gnu
ENV CROSS_ROOT=/usr/${CROSS_TRIPLE}
ENV PATH ${PATH}:${CROSS_ROOT}/bin
RUN mkdir -p ${CROSS_ROOT}/bin
COPY ${CROSS_TRIPLE}.sh ${CROSS_ROOT}/bin/${CROSS_TRIPLE}.sh
COPY ${CROSS_TRIPLE}-as.sh ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as.sh
COPY ${CROSS_TRIPLE}-noop.sh ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-noop.sh
RUN cd ${CROSS_ROOT}/bin && \
  chmod +x ${CROSS_TRIPLE}.sh && \
  ln -s /usr/bin/x86_64-linux-gnu-gcc && \
  ln -s /usr/bin/x86_64-linux-gnu-g++ && \
  ln -s /usr/bin/x86_64-linux-gnu-as && \
  ln -s ${CROSS_TRIPLE}.sh ${CROSS_TRIPLE}-gcc && \
  ln -s ${CROSS_TRIPLE}.sh ${CROSS_TRIPLE}-g++ && \
  ln -s ${CROSS_TRIPLE}-as.sh ${CROSS_TRIPLE}-as && \
  ln -s /usr/bin/x86_64-linux-gnu-ar ${CROSS_TRIPLE}-ar && \
  ln -s ${CROSS_TRIPLE}-noop.sh ${CROSS_TRIPLE}-noop
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++

COPY Toolchain.cmake /usr/lib/${CROSS_TRIPLE}/
ENV CMAKE_TOOLCHAIN_FILE=/usr/lib/${CROSS_TRIPLE}/Toolchain.cmake

# Linux kernel cross compilation variables
ENV CROSS_COMPILE=${CROSS_TRIPLE}-
ENV ARCH=x86

COPY linux32-entrypoint.sh /ocix/
ENTRYPOINT ["/ocix/linux32-entrypoint.sh"]

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
