OCI_EXE=$1
OCIX_ORG=$2
OCIX_IMAGE=$3
OCIX_VERSION=$4
OCIX_DIR=$5
if [ "$(${OCI_EXE} images -q ocix-base:${OCIX_VERSION} 2> /dev/null)" = "" ]
then
	[ ! "${OCIX_DIR}" = "." ] && mkdir -p ${OCIX_DIR}/imagefiles && cp -f -r imagefiles ${OCIX_DIR}/
  ${OCI_EXE} build --tag ${OCIX_ORG}/ocix-base:${OCIX_VERSION} \
    --build-arg IMAGE=${OCIX_ORG}/ocix-base \
    --build-arg OCIX_ORG=${OCIX_ORG} \
    --build-arg OCIX_VERSION=${OCIX_VERSION} \
    --build-arg VCS_URL=`git config --get remote.origin.url` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VCS_URL=`git config --get remote.origin.url` \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --file ${OCIX_DIR}/Dockerfile .
  [ ! "${OCIX_DIR}" = "." ] && rm -rf ${OCIX_DIR}/imagefiles
fi
