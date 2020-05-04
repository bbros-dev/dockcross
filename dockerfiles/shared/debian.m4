# Start include from shared/debian.m4
#
# Image build scripts

WORKDIR /work

COPY scripts/install-gosu-binary.sh \
     scripts/install-gosu-binary-wrapper.sh \
     /buildscripts/

include(shared/aptitude-env.m4)
include(shared/sshd-privilege-separation.m4)

ARG DEBIAN_FRONTEND=noninteractive
ARG REPO=http://deb.debian.org



# Note Debian Buster is Debian 10.x
RUN bash -c "echo \"deb [arch=i386 amd64 armel armhf arm64 mips mips64el mipsel ppc64el s390x] $REPO/debian buster main contrib non-free\" > /etc/apt/sources.list"  && \
    bash -c "echo \"deb [arch=i386 amd64 armel armhf arm64 mips mips64el mipsel ppc64el s390x] $REPO/debian buster-updates main contrib non-free\" >> /etc/apt/sources.list"  && \
    bash -c "echo \"deb [arch=i386 amd64 armel armhf arm64 mips mips64el mipsel ppc64el s390x] $REPO/debian-security buster/updates main\" >> /etc/apt/sources.list" && \
    bash -c "echo \"deb [arch=i386 amd64 armel armhf arm64 mips mips64el mipsel ppc64el s390x] http://deb.debian.org/debian buster-backports main\" >> /etc/apt/sources.list" && \
    dpkg --add-architecture amd64 && \
    apt-get update --yes && \
    apt-get install --no-install-recommends --yes apt-transport-https \
                                                  aptitude && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --without-recommends install \
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
              m4 \
              make \
              ncurses-dev \
              pax \
              pkg-config \
              python3 \
              python3-pip \
              re2c \
              rsync \
              sed \
              ssh \
              tar \
              vim \
              wget \
              xz-utils \
              zip \
              zlib1g-dev && \
    aptitude -f -y -q --no-gui clean && \
    /buildscripts/install-gosu-binary.sh && \
    /buildscripts/install-gosu-binary-wrapper.sh && \
    rm -rf /buildscripts

#
# End include from shared/debian.m4
