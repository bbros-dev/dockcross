# Start include from shared/docker.m4
#
WORKDIR /usr/src

ARG GIT_VERSION=2.26.2
ARG CMAKE_VERSION=3.17.1

# Image build scripts
COPY scripts/build-shared-docker.sh \
      scripts/build-and-install-cmake.sh \
      scripts/build-and-install-curl.sh \
      scripts/build-and-install-git.sh \
      scripts/build-and-install-ninja.sh \
      scripts/build-and-install-openssl.sh \
      scripts/build-and-install-openssh.sh \
      scripts/install-cmake-binary.sh \
      scripts/install-liquidprompt-binary.sh \
      scripts/install-python-packages.sh \
      scripts/utils.sh \
      /buildscripts/

WORKDIR /buildscripts
RUN (/buildscripts/build-shared-docker.sh 2>&1 | tee --append /work/docker.log && \
    touch /work/docker-done) || /bin/true
RUN test -f /work/docker-done || \
    (echo ERROR-------; echo RUN failed, see files in container /work directory of the last container layer; echo Execute docker run '<last image id>' /bin/cat /work/*.log; echo ----------)

RUN test -f /work/docker-done && \
    echo "root:root" | chpasswd
WORKDIR /work
ENTRYPOINT ["/ocix/entrypoint.sh"]

# Runtime scripts
COPY scripts/cmake.sh /usr/local/bin/cmake
COPY scripts/ccmake.sh /usr/local/bin/ccmake
COPY scripts/entrypoint.sh scripts/ocix.m4 /ocix/

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work

#
# End include from shared/docker.m4
