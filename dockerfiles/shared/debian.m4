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
RUN bash -c "echo \"deb [arch=i386,amd64,armel,armhf,arm64,mips,mips64el,mipsel,ppc64el,s390x] $REPO/debian buster main contrib non-free\" > /etc/apt/sources.list"  && \
    bash -c "echo \"deb [arch=i386,amd64,armel,armhf,arm64,mips,mips64el,mipsel,ppc64el,s390x] $REPO/debian buster-updates main contrib non-free\" >> /etc/apt/sources.list"  && \
    bash -c "echo \"deb [arch=i386,amd64,armel,armhf,arm64,mips,mips64el,mipsel,ppc64el,s390x] $REPO/debian-security buster/updates main\" >> /etc/apt/sources.list" && \
    bash -c "echo \"deb [arch=i386,amd64,armel,armhf,arm64,mips,mips64el,mipsel,ppc64el,s390x] http://deb.debian.org/debian buster-backports main\" >> /etc/apt/sources.list" && \
    dpkg --add-architecture amd64 && \
    apt-get update --yes && \
    apt-get install --no-install-recommends --yes \
                    apt-transport-https:amd64 \
                    apt-utils:amd64 \
                    apt-xapian-index:amd64 \
                    aptitude:amd64 \
                    tasksel:amd64 \
                    xapian-tools:amd64 && \
    aptitude -f --no-gui -q -y update && \
    aptitude -f --no-gui -q -y --without-recommends install \
              autogen:amd64 \
              automake:amd64 \
              bash:amd64 \
              bc:amd64 \
              bison:amd64 \
              build-essential:amd64 \
              bzip2:amd64 \
              ca-certificates:amd64 \
              curl:amd64 \
              dirmngr:amd64 \
              file:amd64 \
              flex:amd64 \
              gettext:amd64 \
              gzip:amd64 \
              gnupg:amd64 \
              initramfs-tools:amd64 \
              libtool-bin:amd64 \
              m4:amd64 \
              make:amd64 \
              ncurses-dev:amd64 \
              perl-base:amd64 \
              pax:amd64 \
              pkg-config:amd64 \
              python3:amd64 \
              python3-pip:amd64 \
              re2c:amd64 \
              rsync:amd64 \
              sed:amd64 \
              ssh:amd64 \
              tar:amd64 \
              texinfo:amd64 \
              vim:amd64 \
              wget:amd64 \
              xz-utils:amd64 \
              zip:amd64 \
              zlib1g-dev:amd64 && \
    aptitude -f -y -q --no-gui clean && \
    /buildscripts/install-gosu-binary.sh 2>&1 | tee --append /work/debian.log && \
    /buildscripts/install-gosu-binary-wrapper.sh 2>&1 | tee --append /work/debian.log && \
    rm -rf /buildscripts

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work

#
# End include from shared/debian.m4
