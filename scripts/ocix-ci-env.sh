#!/usr/bin/env bash
echo export OCIX_REGISTRY="$(cat ocix_registry)"
echo export OCIX_API_SERVER="$(cat ocix_api_server)"
PORT="$(cat ocix_port)"
if [ ! "${PORT}x" = "x" ] && [ ! "${PORT:0:1}" = ':' ]
then
  PORT=":${PORT}"
fi
echo export OCIX_PORT="${PORT}"
echo export OCIX_ORG="$(cat ocix_org)"
echo export OCIX_VERSION="$(cat ocix_version)"
