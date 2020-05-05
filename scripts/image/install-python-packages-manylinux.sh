#!/usr/bin/env bash

for PIP in /opt/python/*/bin/pip; do
  $PIP install --disable-pip-version-check --upgrade pip
  $PIP install scikit-build==0.8.1
done

# Setup a consistent python link we can use across all images when running
# integration tests.  This simlifies the OCIX Makefile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
if [ -e /opt/python/cp35-cp35m/bin/python ]
then
  ln -s /opt/python/cp35-cp35m/bin/python /usr/bin/python4ocixtest
else 
  py=$(command -v python || command -v python3 2>/dev/null)
  if [ "${py}" = "" ]
  then
    echo "Found no Python to setup for OCIX testing."
    exit 1
  else
    ln -s ${py} /usr/local/bin/python4ocixtest
  fi
fi
