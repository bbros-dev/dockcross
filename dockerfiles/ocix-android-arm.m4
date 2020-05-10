include(shared/base.m4)

include(shared/aptitude.m4)

include(shared/environment.m4)

# The cross-compiling emulator.  ARMEL should run on most hardware.
RUN  dpkg --add-architecture armel && \
    aptitude update && \
    aptitude install -f --no-gui -q -y --with-recommends \
                      crossbuild-essential-armel \
                      lib32ncurses-dev

ENV CROSS_TRIPLE=arm-linux-androideabi
ENV CROSS_ROOT=/usr/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld \
    FC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gfortran

ENV ANDROID_NDK_REVISION 16b
ENV ANDROID_NDK_API 16
RUN mkdir -p /build && \
    cd /build && \
    curl -O https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip && \
    unzip ./android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip && \
    cd android-ndk-r${ANDROID_NDK_REVISION} && \
    ./build/tools/make_standalone_toolchain.py \
      --arch arm \
      --api ${ANDROID_NDK_API} \
      --stl=libc++ \
      --install-dir=${CROSS_ROOT} && \
    cd / && \
    rm -rf /build && \
    find ${CROSS_ROOT} -exec chmod a+r '{}' \; && \
    find ${CROSS_ROOT} -executable -exec chmod a+x '{}' \;

COPY Toolchain.cmake ${CROSS_ROOT}/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/Toolchain.cmake

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
