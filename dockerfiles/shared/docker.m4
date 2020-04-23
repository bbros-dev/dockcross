WORKDIR /usr/src

ARG GIT_VERSION=2.22.0
ARG CMAKE_VERSION=3.17.1

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

RUN X86_FLAG=$([ "$DEFAULT_OCIX_IMAGE" = "${OCIX_ORG}/manylinux1-x86:${OCIX_VERSION}" -o "$DEFAULT_OCIX_IMAGE" = "${OCIX_ORG}/manylinux2010-x86:${OCIX_VERSION}" ] && echo "-32" || echo "") && \
    /buildscripts/build-and-install-openssl.sh $X86_FLAG && \
    /buildscripts/build-and-install-openssh.sh && \
    /buildscripts/build-and-install-curl.sh && \
    /buildscripts/build-and-install-git.sh && \
    /buildscripts/install-cmake-binary.sh $X86_FLAG && \
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
