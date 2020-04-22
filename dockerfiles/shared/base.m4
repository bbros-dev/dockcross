# NOTE: Arguments are reset to empty after the FROM statement.
#       Unless they are not.
#       This funkyness is from Docker world: 
#       https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#       https://docs.docker.com/engine/reference/builder/#scope
ARG OCIX_IMAGE
ARG OCIX_NAME
ARG OCIX_ORG
ARG OCIX_VERSION
FROM ${OCIX_ORG}/ocix-base:${OCIX_VERSION}
ARG OCIX_IMAGE
ARG OCIX_NAME
ARG OCIX_ORG
ARG OCIX_VERSION
