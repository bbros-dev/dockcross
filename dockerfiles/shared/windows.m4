# Start include from shared/windows.m4
#
#
# Before including this script, make sure to set:
#
# WINEARCH environment variable to either "win64" or "win32"
# MXE_TARGET_ARCH argument to either "x86_64" or "i686". See http://mxe.cc/
# MXE_TARGET_THREAD argument to either "" or ".posix". Default is win32. See http://mxe.cc/
# MXE_TARGET_LINK argument to either "static" or "shared"
#
# For example:
#
#  ENV WINEARCH win64
#  ARG MXE_TARGET_ARCH=x86_64
#  ARG MXE_TARGET_THREAD=
#  ARG MXE_TARGET_LINK=shared
#

include(shared/aptitude-env.m4)

# mxe master 2019-12-06
ARG MXE_GIT_TAG=aab04b93b06892a3dc675c97653236a40858c4a3

ENV MXE_STRING ${MXE_TARGET_ARCH}-w64-mingw32.${MXE_TARGET_LINK}${MXE_TARGET_THREAD}
ENV CMAKE_TOOLCHAIN_FILE /usr/src/mxe/usr/${MXE_STRING}/share/cmake/mxe-conf.cmake

ARG DEBIAN_FRONTEND=noninteractive

#
# WINE is used as an emulator for try_run and tests with CMake.
#
# Other dependencies are from the listed MXE requirements:
#   http://mxe.cc/#requirements
# 'cmake' is omitted because it is installed from source in the base image
#
RUN aptitude update && \
    aptitude -f --no-gui -q -y --without-recommends install \
                      autoconf \
                      automake \
                      autopoint \
                      bash \
                      bison \
                      bzip2 \
                      flex \
                      gettext \
                      git \
                      g++ \
                      g++-multilib \
                      gperf \
                      intltool \
                      libffi-dev \
                      libgdk-pixbuf2.0-dev \
                      libtool-bin \
                      libltdl-dev \
                      libssl-dev \
                      libxml-parser-perl \
                      libc6-dev-i386 \
                      lzip \
                      make \
                      openssl \
                      p7zip-full \
                      patch \
                      perl \
                      pkg-config \
                      python \
                      ruby \
                      scons \
                      sed \
                      wget \
                      wine \
                      xz-utils && \
  #
  # Install Wine
  #
  dpkg --add-architecture i386 && \
  aptitude update && \
  aptitude -f --no-gui -q -y --without-recommends install \
                    unzip:i386 \
                    wine32:i386 && \
  wine hostname && \
  
  #
  # Download MXE sources
  #
  cd /usr/src && \
  git clone https://github.com/mxe/mxe.git && \
  cd mxe && \
  git checkout ${MXE_GIT_TAG} && \
  
  #
  # Configure "settings.mk" required to build MXE
  #
  cd /usr/src/mxe && \
  echo "MXE_TARGETS := ${MXE_STRING}"        > settings.mk && \
  echo "MXE_USE_CCACHE :="                  >> settings.mk && \
  echo "MXE_PLUGIN_DIRS := plugins/gcc9"    >> settings.mk && \
  echo "LOCAL_PKG_LIST := cc cmake"         >> settings.mk && \
  echo ".DEFAULT local-pkg-list:"           >> settings.mk && \
  echo "local-pkg-list: \$(LOCAL_PKG_LIST)" >> settings.mk && \
  
  #
  # Build MXE
  #
  cd /usr/src/mxe && \
  make JOBS=$(nproc) && \
  
  #
  # Cleanup: By keeping the MXE build system (Makefile, ...), derived images
  #           will be able to install additional packages.
  #
  rm -rf log pkg && \
  
  #
  # Update MXE toolchain file
  #
  echo 'set(CMAKE_CROSSCOMPILING_EMULATOR "/usr/bin/wine")' >> ${CMAKE_TOOLCHAIN_FILE} && \
  
  #
  # Replace cmake and cpack binaries
  #
  cd /usr/bin && \
  rm cmake cpack && \
  ln -s /usr/src/mxe/usr/bin/${MXE_STRING}-cmake cmake && \
  ln -s /usr/src/mxe/usr/bin/${MXE_STRING}-cpack cpack

ENV PATH ${PATH}:/usr/src/mxe/usr/bin
ENV CROSS_TRIPLE ${MXE_STRING}
ENV AS=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-as \
    AR=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-ar \
    CC=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-gcc \
    CPP=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-cpp \
    CXX=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-g++ \
    LD=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-ld \
    FC=/usr/src/mxe/usr/bin/${CROSS_TRIPLE}-gfortran

WORKDIR /work

#
# End include from shared/windows.m4
