# Start include from shared/label.m4
#
# OCI container annotations are as defined at:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
ARG OCIX_URL="https://github.com/dockcross/dockcross/blob/master/README.rst"
LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.description=$IMAGE \
      org.opencontainers.image.documentation=$OCIX_URL \
      org.opencontainers.image.licenses="SPDX-License-Identifier: MIT" \
      org.opencontainers.image.ref.name=$IMAGE \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source=$VCS_URL \
      org.opencontainers.image.title=$IMAGE \
      org.opencontainers.image.url=$OCIX_URL \
      org.opencontainers.image.vendor=$OCIX_ORG \
      org.opencontainers.image.version=$OCIX_VERSION

#
# End include from shared/label.m4
