# Start include from shared/label.m4
#
# OCI container annotations are as defined at:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG OCIX_URL="https://github.com/dockcross/dockcross/blob/master/README.md"
LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.description=${OCIX_NAME}:${OCIX_VERSION} \
      org.opencontainers.image.documentation=$OCIX_URL \
      org.opencontainers.image.licenses="SPDX-License-Identifier: MIT" \
      org.opencontainers.image.ref.name=${OCIX_NAME}:${OCIX_VERSION} \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source=$VCS_URL \
      org.opencontainers.image.title=${OCIX_NAME}:${OCIX_VERSION} \
      org.opencontainers.image.url=$OCIX_URL \
      org.opencontainers.image.vendor=$OCIX_ORG \
      org.opencontainers.image.version=$OCIX_VERSION

#
# End include from shared/label.m4
