#!/usr/bin/env bash
OCI_EXE=$1
OCIX_ORG=$2
OCIX_IMAGE=$3
OCIX_VERSION=$4
OCIX_DIR=$5

function oci_tag_exists() {
  local TOKEN
  local EXISTS
  TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${OCIX_REGISTRY_USER}'", "password": "'${OCIX_REGISTRY_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
  EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://${OCIX_REGISTRY}${OCIX_PORT}/v2/repositories/$1/tags/?page_size=1 | jq -r "[.results | .[] | .name == \"$2\"] | any")
  test "$EXISTS" = "true"
}

if oci_tag_exists ${OCIX_ORG}/${OCIX_IMAGE} ${OCIX_VERSION}
then
  m4 -I ./dockerfiles ./dockerfiles/${OCIX_IMAGE}.m4 > ${OCIX_DIR}/Dockerfile
	mkdir -p ${OCIX_DIR}/scripts 
  cp -f scripts/image/*.sh ${OCIX_DIR}/scripts/
  ${OCI_EXE} build --tag ${OCIX_REGISTRY}${OCIX_PORT}/${OCIX_ORG}/${OCIX_IMAGE}:${OCIX_VERSION} \
    --build-arg IMAGE=${OCIX_ORG}/${OCIX_IMAGE} \
    --build-arg OCIX_ORG=${OCIX_ORG} \
    --build-arg OCIX_VERSION=${OCIX_VERSION} \
    --build-arg VCS_URL=$(git config --get remote.origin.url) \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --file ${OCIX_DIR}/Dockerfile ${OCIX_DIR}
  rm -rf ${OCIX_DIR}/scripts
  rm -f ${OCIX_DIR}/Dockerfile
fi
