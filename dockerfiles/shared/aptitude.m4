# Start include from shared/aptitude-env.m4
#

ARG OCIX_IMAGE=${OCIX_IMAGE}
ARG OCIX_NAME=${OCIX_NAME}
ARG OCIX_ORG=${OCIX_ORG}
ARG OCIX_VERSION=${OCIX_VERSION}

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

COPY scripts/apt-config.sh \
     scripts/ocix-env.sh \
     /buildscripts/

RUN /buildscripts/apt-config.sh && \
    /buildscripts/ocix-env.sh

#
# End include from shared/aptitude-env.m4
