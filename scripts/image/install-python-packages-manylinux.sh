#!/usr/bin/env bash

for PIP in /opt/python/*/bin/pip; do
  $PIP install --disable-pip-version-check --upgrade pip
  $PIP install scikit-build==0.8.1
done

# Setup a consistent python link we can use across all images when running
# integration tests.  This simlifies the OCIX Makefile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
ln -s ${PYTHON} /usr/local/bin/python4ocixtest
