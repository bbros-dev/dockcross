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

RUN echo $'#!/usr/bin/env bash\n\
OCIX_IMAGE='$OCIX_IMAGE$'\n\
OCIX_NAME='$OCIX_NAME$'\n\
OCIX_ORG='$OCIX_ORG$'\n\
OCIX_VERSION='$OCIX_VERSION$'\n\
DEFAULT_OCIX_IMAGE='$OCIX_NAME:$OCIX_VERSION$'\n '\
>> /etc/profile.d/00-ocix-env.sh
