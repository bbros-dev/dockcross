#!/usr/bin/env bash

# A better class of script...
if [[ ${DEBUG-} =~ ^1|[yY]|yes|[tT]|true$ ]]; then
  set -o xtrace       # Trace the execution of the script (debug)
fi

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

./build-and-install-openssl.sh ${DEFAULT_OCIX_IMAGE}
./build-and-install-openssh.sh
./build-and-install-curl.sh
./build-and-install-git.sh
./install-cmake-binary.sh ${DEFAULT_OCIX_IMAGE}
./install-liquidprompt-binary.sh
./install-python-packages.sh
./build-and-install-ninja.sh
