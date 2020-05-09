include(shared/base.m4)

include(shared/aptitude-env.m4)

RUN dpkg --add-architecture amd64 && \
    aptitude -f --no-gui -q -y --with-recommends install \
              crossbuild-essential-amd64

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /usr/bin
ENV AS=/usr/bin/${CROSS_TRIPLE}-as \
    AR=/usr/bin/${CROSS_TRIPLE}-ar \
    CC=/usr/bin/${CROSS_TRIPLE}-gcc \
    CPP=/usr/bin/${CROSS_TRIPLE}-cpp \
    CXX=/usr/bin/${CROSS_TRIPLE}-g++ \
    LD=/usr/bin/${CROSS_TRIPLE}-ld \
    FC=/usr/bin/${CROSS_TRIPLE}-gfortran

COPY scripts/${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY Toolchain.cmake /usr/lib/${CROSS_TRIPLE}/
ENV CMAKE_TOOLCHAIN_FILE=/usr/lib/${CROSS_TRIPLE}/Toolchain.cmake

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
