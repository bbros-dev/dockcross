#!/usr/bin/env bash
echo export OCIX_REGISTRY="$(cat ocix_registry)"
port="$(cat ocix_port)"
if [ ! "${port}x" = "x" ] && [ ! "${port:0:1}" = ':' ]
then
  port=":${port}"
fi
echo export OCIX_PORT="$port"
echo export OCIX_ORG="$(cat ocix_org)"
echo export OCIX_VERSION="$(cat ocix_version)"
