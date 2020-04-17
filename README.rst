dockcross
=========

Cross compiling toolchains in OCI container images.

.. image:: https://circleci.com/gh/dockcross/dockcross/tree/master.svg?style=svg
  :target: https://circleci.com/gh/dockcross/dockcross/tree/master

Features
--------

* Supports `Docker <https://www.docker.com/>`_ and `Podman <https://podman.io/>`_
  container engines.
* Supports `Open Container Initiative (OCI) <https://www.opencontainers.org/>`_
  compatible containers and registries.
* Supports use cases where code and containers must be self-hosted. See
  Self-Hosting below.
* Pre-built and configured toolchains for cross compiling.
* Most images also contain an emulator for the target system.
* Clean separation of build tools, source code, and build artifacts.
* Commands in the container are run as the calling user, so that any created files have the expected ownership, (i.e. not root).
* Make variables (`CC`, `LD` etc) are set to point to the appropriate tools in the container.
* Recent `CMake <https://cmake.org>`_ and ninja are precompiled.
* `Conan.io <https://www.conan.io>`_ can be used as a package manager.
* Toolchain files configured for CMake.
* Current directory is mounted as the container's workdir, ``/work``.
* Works with the `Docker for Mac <https://docs.docker.com/docker-for-mac/>`_ and `Docker for Windows <https://docs.docker.com/docker-for-windows/>`_.

Examples
--------

1. ``ocix make``: Build the *Makefile* in the current directory.
2. ``ocix cmake -Bbuild -H. -GNinja``: Run CMake with a build directory
   ``./build`` for a *CMakeLists.txt* file in the current directory and generate
   ``ninja`` build configuration files.
3. ``ocix ninja -Cbuild``: Run ninja in the ``./build`` directory.
4. ``ocix bash -c '$CC test/C/hello.c -o hello'``: Build the *hello.c* file
   with the compiler identified with the ``CC`` environmental variable in the
   build environment.
5. ``ocix bash``: Run an interactive shell in the build environment.

Note that commands are executed verbatim. If any shell processing for
environment variable expansion or redirection is required, please use
`bash -c 'command args...'`.

Installation
------------

This image does not need to be run manually. Instead, there is a helper script
to execute build commands on source code existing on the local host filesystem. This
script is bundled with the image.

To install the helper script, run one of the images with no arguments, and
redirect the output to a file::

  docker run --rm CROSS_COMPILER_IMAGE_NAME > ./ocix
  chmod +x ./ocix
  mv ./ocix ~/bin/

Podman users can replace `docker` with `podman` in all documentation examples::

  podman run --rm CROSS_COMPILER_IMAGE_NAME > ./ocix
  chmod +x ./ocix
  mv ./ocix ~/bin/

Where `CROSS_COMPILER_IMAGE_NAME` is the name of the cross-compiler toolchain
container 'slug', e.g. `dockcross/linux-armv7`.

Only 64-bit x86_64 images are provided; a 64-bit x86_64 host system is required.

Usage
-----

For the impatient, here's how to compile a hello world for armv7 using Docker::

  cd ~/src/ocix
  docker run --rm ocix/linux-armv7 > ./ocix-linux-armv7
  chmod +x ./ocix-linux-armv7
  ./ocix-linux-armv7 bash -c '$CC test/C/hello.c -o hello_arm'

Note how invoking any toolchain command (make, gcc, etc.) is just a matter of
prepending the **ocix** script on the commandline::

  ./ocix-linux-armv7 [command] [args...]

The **ocix** script will select between the `docker` and `podman` container
engines, then execute the given command-line inside the container,
along with all arguments passed after the command. 
If `podman` is installed and responds to `command -v podman` it is selected.
Otherwise, the default container engine executable is `docker`. 

Commands that evaluate environmental variables in the image, like `$CC` above,
should be executed in `bash -c`. 
The present working directory is mounted within the image, which can be used to
make source code available in the container.

Cross compilers
---------------

.. |base-images| image:: https://images.microbadger.com/badges/image/dockcross/ocix-base.svg
  :target: https://microbadger.com/images/dockcross/ocix-base

dockcross/base
  |base-images| Base image for other toolchain images. From Debian 10 (Buster)
   with GCC, make, autotools, CMake, Ninja, Git, and Python.

.. |android-arm-images| image:: https://images.microbadger.com/badges/image/dockcross/android-arm.svg
  :target: https://microbadger.com/images/dockcross/android-arm

dockcross/android-arm
  |android-arm-images| The Android NDK standalone toolchain for the arm
  architecture.
.. |android-arm64-images| image:: https://images.microbadger.com/badges/image/dockcross/android-arm64.svg
  :target: https://microbadger.com/images/dockcross/android-arm64

dockcross/android-arm64
  |android-arm64-images| The Android NDK standalone toolchain for the arm64
  architecture.
.. |linux-arm64-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-arm64.svg
  :target: https://microbadger.com/images/dockcross/linux-arm64

dockcross/linux-arm64
  |linux-arm64-images| Cross compiler for the 64-bit ARM platform on Linux,
  also known as AArch64.
.. |linux-armv5-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-armv5.svg
  :target: https://microbadger.com/images/dockcross/linux-armv5

dockcross/linux-armv5
  |linux-armv5-images| Linux armv5 cross compiler toolchain for legacy devices
  like the Parrot AR Drone.
.. |linux-armv5-musl-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-armv5-musl.svg
  :target: https://microbadger.com/images/dockcross/linux-armv5-musl

dockcross/linux-armv5-musl
  |linux-armv5-musl-images| Linux armv5 cross compiler toolchain using `musl <https://www.musl-libc.org/>`_ as base "libc".
.. |linux-armv6-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-armv6.svg
  :target: https://microbadger.com/images/dockcross/linux-armv6

dockcross/linux-armv6
  |linux-armv6-images| Linux ARMv6 cross compiler toolchain for the Raspberry
  Pi, etc.
.. |linux-armv7-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-armv7.svg
  :target: https://microbadger.com/images/dockcross/linux-armv7

dockcross/linux-armv7
  |linux-armv7-images| Generic Linux armv7 cross compiler toolchain.
.. |linux-armv7a-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-armv7a.svg
  :target: https://microbadger.com/images/dockcross/linux-armv7a

dockcross/linux-armv7a
  |linux-armv7a-images| Toolchain configured for ARMv7-A used in Beaglebone Black single board PC with TI SoC AM3358 on board, Cortex-A8.

.. |linux-mipsel-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-mipsel.svg
  :target: https://microbadger.com/images/dockcross/linux-mipsel

dockcross/linux-mipsel
  |linux-mipsel-images| Linux mipsel cross compiler toolchain for little endian MIPS GNU systems.

.. |linux-mips-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-mips.svg
  :target: https://microbadger.com/images/dockcross/linux-mips

dockcross/linux-mips
  |linux-mips-images| Linux mips cross compiler toolchain for big endian 32-bit hard float MIPS GNU systems.

.. |linux-s390x-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-s390x.svg
  :target: https://microbadger.com/images/dockcross/linux-s390x

dockcross/linux-s390x
  |linux-s390x-images| Linux s390x cross compiler toolchain for S390X GNU systems.

.. |linux-ppc64el-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-ppc64el.svg
  :target: https://microbadger.com/images/dockcross/linux-ppc64el

dockcross/linux-ppc64el
  |linux-ppc64el-images| Linux PowerPC 64 little endian cross compiler
  toolchain for the POWER8, etc.
.. |linux-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-x64.svg
  :target: https://microbadger.com/images/dockcross/linux-x64

dockcross/linux-x64
  |linux-x64-images| Linux x86_64 / amd64 compiler. Since the container image is
  natively x86_64, this is not actually a cross compiler.
.. |linux-x86-images| image:: https://images.microbadger.com/badges/image/dockcross/linux-x86.svg
  :target: https://microbadger.com/images/dockcross/linux-x86

dockcross/linux-x86
  |linux-x86-images| Linux i686 cross compiler.
.. |manylinux2014-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/manylinux2014-x64.svg
  :target: https://microbadger.com/images/dockcross/manylinux2014-x64

dockcross/manylinux2014-x64
  |manylinux2014-x64-images| `manylinux2014 <https://github.com/pypa/manylinux>`_ container image for building Linux x86_64 / amd64 `Python wheel packages <http://pythonwheels.com/>`_. It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
  Also has support for the dockcross script, and it has installations of CMake, Ninja, and `scikit-build <http://scikit-build.org>`_. For CMake, it sets `MANYLINUX2014` to "TRUE" in the toolchain.
.. |manylinux2010-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/manylinux2010-x64.svg
  :target: https://microbadger.com/images/dockcross/manylinux2010-x64

dockcross/manylinux2010-x64
  |manylinux2010-x64-images| `manylinux2010 <https://github.com/pypa/manylinux>`_ container image for building Linux x86_64 / amd64 `Python wheel packages <http://pythonwheels.com/>`_. It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
  Also has support for the dockcross script, and it has installations of CMake, Ninja, and `scikit-build <http://scikit-build.org>`_. For CMake, it sets `MANYLINUX2010` to "TRUE" in the toolchain.
.. |manylinux2010-x86-images| image:: https://images.microbadger.com/badges/image/dockcross/manylinux2010-x86.svg
  :target: https://microbadger.com/images/dockcross/manylinux2010-x86

dockcross/manylinux2010-x86
  |manylinux2010-x86-images| `manylinux2010 <https://github.com/pypa/manylinux>`_ container image for building Linux i686 `Python wheel packages <http://pythonwheels.com/>`_. It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
  Also has support for the dockcross script, and it has installations of CMake, Ninja, and `scikit-build <http://scikit-build.org>`_. For CMake, it sets `MANYLINUX2010` to "TRUE" in the toolchain.
.. |manylinux1-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/manylinux1-x64.svg
  :target: https://microbadger.com/images/dockcross/manylinux1-x64

dockcross/manylinux1-x64
  |manylinux1-x64-images| `manylinux1 <https://github.com/pypa/manylinux/tree/manylinux1>`_ container image for building Linux x86_64 / amd64 `Python wheel packages <http://pythonwheels.com/>`_. It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
  Also has support for the dockcross script, and it has installations of CMake, Ninja, and `scikit-build <http://scikit-build.org>`_. For CMake, it sets `MANYLINUX1` to "TRUE" in the toolchain.
.. |manylinux1-x86-images| image:: https://images.microbadger.com/badges/image/dockcross/manylinux1-x86.svg
  :target: https://microbadger.com/images/dockcross/manylinux1-x86

dockcross/manylinux1-x86
  |manylinux1-x86-images| `manylinux1 <https://github.com/pypa/manylinux/tree/manylinux1>`_ container image for building Linux i686 `Python wheel packages <http://pythonwheels.com/>`_. It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
  Also has support for the dockcross script, and it has installations of CMake, Ninja, and `scikit-build <http://scikit-build.org>`_. For CMake, it sets `MANYLINUX1` to "TRUE" in the toolchain.
.. |web-wasm-images| image:: https://images.microbadger.com/badges/image/dockcross/web-wasm.svg
  :target: https://microbadger.com/images/dockcross/web-wasm

dockcross/web-wasm
  |web-wasm-images| The Emscripten WebAssembly/asm.js/JavaScript cross compiler.
.. |windows-static-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-static-x64.svg
  :target: https://microbadger.com/images/dockcross/windows-static-x64

dockcross/windows-static-x64
  |windows-static-x64-images| 64-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with win32 threads and static linking.
.. |windows-static-x64-posix-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-static-x64-posix.svg
  :target: https://microbadger.com/images/dockcross/windows-static-x64-posix

dockcross/windows-static-x64-posix
  |windows-static-x64-posix-images| 64-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with posix threads and static linking.
.. |windows-static-x86-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-static-x86.svg
  :target: https://microbadger.com/images/dockcross/windows-static-x86

dockcross/windows-static-x86
  |windows-static-x86-images| 32-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with win32 threads and static linking.

.. |windows-shared-x64-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-shared-x64.svg
  :target: https://microbadger.com/images/dockcross/windows-shared-x64

dockcross/windows-shared-x64
  |windows-shared-x64-images| 64-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with win32 threads and dynamic linking.
.. |windows-shared-x64-posix-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-shared-x64-posix.svg
  :target: https://microbadger.com/images/dockcross/windows-shared-x64-posix

dockcross/windows-shared-x64-posix
  |windows-shared-x64-posix-images| 64-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with posix threads and dynamic linking.
.. |windows-shared-x86-images| image:: https://images.microbadger.com/badges/image/dockcross/windows-shared-x86.svg
  :target: https://microbadger.com/images/dockcross/windows-shared-x86

dockcross/windows-shared-x86
  |windows-shared-x86-images| 32-bit Windows cross-compiler based on `MXE/MinGW-w64`_ with win32 threads and dynamic linking.
Articles
--------

- `dockcross: C++ Write Once, Run Anywhere
  <https://nbviewer.jupyter.org/format/slides/github/dockcross/cxx-write-once-run-anywhere/blob/master/dockcross_CXX_Write_Once_Run_Anywhere.ipynb#/>`_
- `Cross-compiling binaries for multiple architectures with Docker
  <https://web.archive.org/web/20170912153531/http://blogs.nopcode.org/brainstorm/2016/07/26/cross-compiling-with-docker>`_
Built-in update commands
------------------------

A special update command can be executed that will update the
source cross-compiler container image or the ocix script itself.

- ``ocix [--] command [args...]``: Forces a command to run inside the
  container (in case of a name clash with a built-in command), use ``--``
  before the command.
- ``ocix update-image``: Fetch the latest version of the container image.
- ``ocix update-script``: Update the installed ocix script with the
  one bundled in the image.
- ``ocix update``: Update both the container image, and the ocix script.
Download all images
-------------------

To easily download all images, the convenience target ``display_images`` could
be used::

  curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
  for image in $(make -f ocix-Makefile display_images); do
    echo "Pulling ocix/$image"
    docker pull ocix/$image
  done

For Podman users, set ``OCI_EXE=podman`` when invoking a ``make`` target::

  curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
  for image in $(make OCI_EXE=podman -f ocix-Makefile display_images); do
    echo "Pulling ocix/$image"
    podman pull ocix/$image
  done

Install all ocix scripts
-----------------------------

To automatically install in ``~/bin`` the ocix scripts for each images
already downloaded, the convenience target ``display_images`` could be used::

  curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
  for image in $(make -f ocix-Makefile display_images); do
    if [[ $(docker images -q ocix/$image) == "" ]]; then
      echo "~/bin/ocix-$image skipping: image not found locally"
      continue
    fi
    echo "~/bin/ocix-$image ok"
    docker run ocix/$image > ~/bin/ocix-$image && \
    chmod u+x  ~/bin/ocix-$image
  done

For Podman users, set ``OCI_EXE=podman`` when invoking a ``make`` target::

  curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
  for image in $(make OCI_EXE=podman -f ocix-Makefile display_images); do
    if [[ $(podman images -q ocix/$image) == "" ]]; then
      echo "~/bin/ocix-$image skipping: image not found locally"
      continue
    fi
    echo "~/bin/ocix-$image ok"
    podman run ocix/$image > ~/bin/ocix-$image && \
    chmod u+x  ~/bin/ocix-$image
  done

Dockcross configuration
-----------------------

The following environmental variables and command-line options are used. In
all cases, the command-line option overrides the environment variable.

DOCKCROSS_CONFIG / --config|-c <path-to-config-file>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This file is sourced, if it exists, before executing the rest of the ocix
script.

Default: ``~/.ocix``

OCIX_IMAGE / --image|-i <container-image-name>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The cross-compiler container image to run.

Default: Image with which the script was created.

DOCKCROSS_ARGS / --args|-a <container-run-args>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Extra arguments to pass to the ``docker run`` or ``podman run`` command.
Quote the entire set of args if they contain spaces.
Per-project ocix configuration
-----------------------------------

If a shell script named ``.ocix`` is found in the current directory where
the ocix script is started, it is executed before the ocix script
``command`` argument.  The shell script is expected to have a shebang like
``#!/usr/bin/env bash``.

For example, commands like ``git config --global advice.detachedHead false`` can
be added to this script.
How to extend Dockcross images
------------------------------
In order to extend Dockcross images with your own commands, one must:

1. Use ``FROM <registry>/<org_name>/<name_of_image>``.
2. Set ``DEFAULT_OCIX_IMAGE`` to a name you're planning to use
   for the image. This name must then be used during the build phase, unless you
   mean to pass the resulting helper script the ``OCIX_IMAGE`` argument.

An example Dockerfile would be::

  FROM docker.io/dockcross/ocix-linux-armv7:2.0.0

  ENV DEFAULT_OCIX_IMAGE my_cool_image
  RUN apt-get install nano

And then in the shell::

  docker build -t my_cool_image .         # Builds the ocix image.
  docker run my_cool_image > linux-armv7  # Creates a helper script named linux-armv7.
  chmod +x linux-armv7                    # Gives the script execution permission.
  ./linux-armv7 bash                      # Runs the helper script with the argument "bash", which starts an interactive container using your extended image.

Self-Hosting
============

Some use cases require that all code and infrastructure be under the control of
an organization (e.g. regulated industries).
This code base aims to support such use cases. The following describes how to
setup one pipeline and does not cover configuring Git server, CI/CD server, or
OCI registry.
The images created are prefixed with ``ocix-*`` to prevent clashes with existing
container image names in your registry.

We welcome Pull-Requests adding support and instructions for other services.

GitHub + CircleCI + Docker.io
-----------------------------

1. Fork the repository ``dockcross/dockcross`` to ``YourOrg/YourName``.
1. Clone your fork to you local computer.
1. Add your container registry name to the file ``ocix_registry``. 
   Example: If you use commands such as ``docker login https://oci.example.com``
   and ``docker pull oci.example.com/my-image``, then add ``oci.example.com``
   to the file ``ocix_registry``. Default: ``docker.io``.
1. Add your container registry port number to the file ``ocix_port``.
   Default: ``443``.
1. If you wish to make these containers available from your container registry
   under the organization/user name ``MyProject`` (does not have to match the
   Git server organization/user) then add ``MyProject`` to the file ``ocix_org``.
   Default: ``dockcross``
1. Add the git repository to you CircleCI account. Then:
   a. Select CircleCI Project settings.
   b. Select Environment variables.
   c. Add ``OCIX_REGISTRY_USER`` with your OCI registry user name.
   d. Add ``OCIX_REGISTRY_PASSWORD`` with your OCI registry password.
What is the difference between `dockcross` and `dockbuild` ?
------------------------------------------------------------

The key difference is that `dockbuild
<https://github.com/dockbuild/dockbuild#readme>`_ images do **NOT** provide
a `toolchain file
<https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html>`_
but they use the same method
to conveniently isolate the build environment as `dockcross
<https://github.com/dockcross/dockcross#readme>`_.

`dockbuild` is used to build binaries for Linux x86_64 / amd64 that will work
across most Linux  distributions. `dockbuild` performs a native Linux build
where the host build system is a Linux x86_64 / amd64 container image (so that
it can be used for building binaries on any system which can run Open Container
Initiative compatible container images) and the target runtime system is Linux
x86_x64 / amd64.

`ocix` is used to build binaries for many different platforms.
`ocix` performs a cross compilation where the host build system is a
Linux x86_64 / amd64 container image (so that it can be used for building
binaries on any system which can run Open Container Initiative compatible
container images) and the target runtime system varies.
---

Credits go to `sdt/docker-raspberry-pi-cross-compiler <https://github.com/sdt/docker-raspberry-pi-cross-compiler>`_, who invented the base of the **dockcross** script.

.. _MXE/MinGW-w64: https://mxe.cc/
