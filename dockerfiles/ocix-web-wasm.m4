FROM trzeci/emscripten-fastcomp:sdk-tag-1.39.10-64bit

include(shared/aptitude-env.m4)
include(shared/sshd-privilege-separation.m4)

# Revert back to "/bin/sh" as default shell
# See https://github.com/asRIA/emscripten-docker/blob/master/Dockerfile.in#L4
RUN rm /bin/sh && ln -s /bin/dash /bin/sh

COPY scripts/install-gosu-binary.sh \
     scripts/install-gosu-binary-wrapper.sh \
     /buildscripts/

ARG DEBIAN_FRONTEND=noninteractive
ARG REPO=http://cdn-fastly.deb.debian.org

RUN \
  bash -c "echo \"deb $REPO/debian buster main contrib non-free\" > /etc/apt/sources.list"  && \
  bash -c "echo \"deb $REPO/debian buster-updates main contrib non-free\" >> /etc/apt/sources.list"  && \
  bash -c "echo \"deb $REPO/debian-security buster/updates main\" >> /etc/apt/sources.list" && \
  bash -c "echo \"deb http://deb.debian.org/debian buster-backports main\" >> /etc/apt/sources.list" && \
  apt-get update --yes && \
  apt-get install --no-install-recommends --yes aptitude && \
  aptitude update  -f --no-gui -q -y&& \
  aptitude install -f --no-gui -q -y --without-recommends \
                    autogen \
                    automake \
                    bash \
                    bc \
                    bison \
                    build-essential \
                    bzip2 \
                    ca-certificates \
                    curl \
                    dirmngr \
                    file \
                    flex \
                    gettext \
                    gzip \
                    gnupg \
                    initramfs-tools \
                    libtool-bin \
                    make \
                    ncurses-dev \
                    pax \
                    pkg-config \
                    python \
                    python-pip \
                    rsync \
                    sed \
                    ssh \
                    tar \
                    vim \
                    wget \
                    xz-utils \
                    zip \
                    zlib1g-dev && \
  aptitude clean  -f --no-gui -q -y&& \
  /buildscripts/install-gosu-binary.sh && \
  /buildscripts/install-gosu-binary-wrapper.sh && \
  rm -rf /buildscripts

include(shared/docker.m4)

ENV EMSCRIPTEN_VERSION 1.39.10

ENV PATH /emsdk_portable:/emsdk_portable/llvm/clang/bin/:/emsdk_portable/emscripten/sdk:${PATH}
ENV CC=/emsdk_portable/emscripten/sdk/emcc \
  CXX=/emsdk_portable/emscripten/sdk/em++ \
  AR=/emsdk_portable/emscripten/sdk/emar
ENV CMAKE_TOOLCHAIN_FILE /emsdk_portable/emscripten/sdk/cmake/Modules/Platform/Emscripten.cmake

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
