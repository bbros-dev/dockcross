#!/usr/bin/env bash

set -ex
set -o pipefail

ARCH="x86_64"

while [ $# -gt 0 ]; do
  X86_FLAG=$([ $1 =~ '-x86' ] && echo "-32" || echo "") 
  case "${X86_FLAG}" in
    -32)
      ARCH="x86"
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-32]"
      exit 1
      ;;
  esac
  shift
done

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

if ! command -v tar &> /dev/null; then
	echo >&2 'error: "tar" not found!'
	exit 1
fi

if [[ "${CMAKE_VERSION}" == "" ]]; then
  echo >&2 'error: CMAKE_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

CMAKE_ROOT=cmake-${CMAKE_VERSION}-Centos5-${ARCH}
url=https://github.com/dockbuild/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_ROOT}.tar.gz
echo "Downloading $url"
curl -# -LO $url

tar -xzf ${CMAKE_ROOT}.tar.gz --no-same-owner
rm -f ${CMAKE_ROOT}.tar.gz

cd ${CMAKE_ROOT}

rm -rf doc man
rm -rf bin/cmake-gui

find . -type f -exec install -D "{}" "/usr/{}" \;
