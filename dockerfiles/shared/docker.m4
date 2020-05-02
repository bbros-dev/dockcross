# Start include from shared/docker.m4
#
WORKDIR /usr/src

ARG GIT_VERSION=2.26.2
ARG CMAKE_VERSION=3.17.2

# Image build scripts
COPY scripts/build-and-install-cmake.sh \
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

RUN /buildscripts/build-and-install-openssl.sh $DEFAULT_OCIX_IMAGE && \
    /buildscripts/build-and-install-openssh.sh && \
    /buildscripts/build-and-install-curl.sh && \
    /buildscripts/build-and-install-git.sh && \
    /buildscripts/install-cmake-binary.sh $DEFAULT_OCIX_IMAGE && \
    /buildscripts/install-liquidprompt-binary.sh && \
    PYTHON=$([ -e /opt/python/cp35-cp35m/bin/python ] && echo "/opt/python/cp35-cp35m/bin/python" || command -v python 2>/dev/null) && \
    /buildscripts/install-python-packages.sh -python ${PYTHON} && \
    /buildscripts/build-and-install-ninja.sh -python ${PYTHON} && \
    rm -rf /buildscripts

RUN echo "root:root" | chpasswd
WORKDIR /work
ENTRYPOINT ["/ocix/entrypoint.sh"]

# Runtime scripts
COPY scripts/cmake.sh /usr/local/bin/cmake
COPY scripts/ccmake.sh /usr/local/bin/ccmake
COPY scripts/entrypoint.sh scripts/ocix.m4 /ocix/

#
# End include from shared/docker.m4
