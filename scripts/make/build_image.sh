#!/usr/bin/env bash
set -o xtrace

OCI_EXE=$1
OCIX_ORG=$2
OCIX_IMAGE=$3
OCIX_VERSION=$4
OCIX_DIR=$5

function oci_tag_exists() {
  local TOKEN
  local EXISTS
  local U=${OCIX_REGISTRY_USER}
  local P=${OCIX_REGISTRY_PASSWORD}
  local R=${OCIX_REGISTRY}${OCIX_PORT}
  local A=${OCIX_API_SERVER}
  # get token to be able to talk to Docker Hub
  TOKEN=$(curl --location \
               --silent \
               --header "Content-Type: application/json" \
               --request POST \
               --data '{"username": "'${U}'", "password": "'${P}'"}' \
               https://${L}/v2/users/login/ | \
               jq -r .token)
  EXISTS=$(curl --location \
                --silent \
                --header "Authorization: JWT ${TOKEN}" \
                https://${L}/v2/repositories/$1/tags/?page_size=1000 | \
                jq -r "[.results | .[] | .name == \"$2\"] | any")
  test "${EXISTS}" = "true"
}

if ! oci_tag_exists ${OCIX_ORG}/${OCIX_IMAGE} ${OCIX_VERSION}
then
  m4 --include=./dockerfiles ./dockerfiles/${OCIX_IMAGE}.m4 > ${OCIX_DIR}/Dockerfile
	mkdir -p ${OCIX_DIR}/scripts 
  cp -f scripts/image/*.sh ${OCIX_DIR}/scripts/
  ${OCI_EXE} build --tag ${OCIX_REGISTRY}${OCIX_PORT}/${OCIX_ORG}/${OCIX_IMAGE}:${OCIX_VERSION} \
    --build-arg OCIX_IMAGE=${OCIX_IMAGE} \
    --build-arg OCIX_NAME=${OCIX_ORG}/${OCIX_IMAGE} \
    --build-arg OCIX_ORG=${OCIX_ORG} \
    --build-arg OCIX_VERSION=${OCIX_VERSION} \
    --build-arg VCS_URL=$(git config --get remote.origin.url) \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --file ${OCIX_DIR}/Dockerfile ${OCIX_DIR}
  rm -rf ${OCIX_DIR}/scripts
  rm -f ${OCIX_DIR}/Dockerfile
fi
