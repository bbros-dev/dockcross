#!/usr/bin/env bash

set -e
set -o pipefail

if [ -e /opt/python/cp35-cp35m/bin/python ]
then
  PYTHON=/opt/python/cp35-cp35m/bin/python
else 
  PYTHON=$(command -v python 2>/dev/null)
  if [ "${PYTHON}" = "" ]
  then
    echo "Found no Python to setup for OCIX testing."
    exit 1
fi

while [ $# -gt 0 ]; do
  case "$1" in
    -python)
      PYTHON=$2
      shift
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-python /path/to/bin/python]"
      exit 1
      ;;
  esac
  shift
done

cd /tmp

curl -# -LO https://bootstrap.pypa.io/get-pip.py
${PYTHON} get-pip.py --ignore-installed
rm get-pip.py

${PYTHON} -m pip install --upgrade --ignore-installed setuptools
${PYTHON} -m pip install --ignore-installed conan

# Setup a consistent python link we can use across all images when running
# integration tests.  This simlifies the OCIX Makefile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
ln -s ${PYTHON} /usr/local/bin/python4ocixtest
