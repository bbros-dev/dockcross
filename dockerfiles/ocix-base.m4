FROM debian:10.3-slim

include(shared/debian.m4)

include(shared/docker.m4)

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
