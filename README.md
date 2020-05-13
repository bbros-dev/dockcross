# ocix

[Self hostable]() cross compiling toolchains in OCI container images.

[![Master](https://circleci.com/gh/begleybrothers/ocix.svg?style=svg)](https://app.circleci.com/pipelines/github/begleybrothers/ocix?branch=master)
[![Development](https://circleci.com/gh/bbros-dev/ocix/tree/develop.svg?style=svg)](https://app.circleci.com/pipelines/github/bbros-dev/ocix?branch=develop)

## Features

- Supports [Docker](https://www.docker.com/) and [Podman](https://podman.io/)
  container engines at build-time and at runtime.
- Supports [Open Container Initiative (OCI)](https://www.opencontainers.org/)
  compatible containers and registries.
- Supports use cases where code and containers must be self-hosted. See
  Self-Hosting below. To see a list of containers available: `make list`.
- Supports single container use cases where this project is a
  [git-subrepo](https://github.com/ingydotnet/git-subrepo) of a project:
  `make ocix-linux-x64` builds and uploads to **your OCI-registry** the
  container `ocix-linux-x64`. See Se-Hosting below.
- Pre-built and configured toolchains for cross compiling.
- Most images also contain an emulator for the target system.
- Clean separation of build tools, source code, and build artifacts.
- Commands in the container are run as the calling user, so that any created
  files have the expected ownership, (i.e. not ro).
- Make variables (CC, LD etc) are set to point to the appropriate tools in the
  container.
- Recent [CMake](https://cmake.org) and ninja are precompiled.
- [Conan.io](https://www.conan.io) can be used as a package manager.
- Toolchain files configured for CMake.
- Current directory is mounted as the container's workdir, `/work`.
- Works with the [Docker for Mac](https://docs.docker.com/docker-for-mac/) and
  [Docker for Windows](https://docs.docker.codocker-for-windows/).

## Installation

This image does not need to be run manually.
Instead, there is a helper script to execute build commands on source code
existing on the local host filesystem. This script is bundled with the image.

To install the helper script, run one of the images with no arguments, and redirect the output to a file:

```bash
IMAGE=yelgeb/ocix-linux-x64:2.0.0
docker run --rm ${IMAGE} > ~/.local/share/bin/ocix
chmod a+x ~/.local/share/bin/ocix
```

Podman users can replace docker with podman in all documentation examples:

```bash
IMAGE=yelgeb/ocix-linux-x64:2.0.0
podman run --rm ${IMAGE} > ~/.local/share/bin/ocix
chmod a+x ~/.local/share/bin/ocix
```

### Examples

1. `ocix cmake -Bbuild -H. -GNinja`: Run CMake with a build directory
   `./build` for a *CMakeLists.txt* file in the current directory and generate
   `ninja` build configuration files.
1. `ocix ninja -Cbuild`: Run ninja in the `./build` directory.
1. `ocix bash -c '$CC test/C/hello.c -o hello'`: Build the *hello.c* file with
   the compiler identified with the `CC` environmental variable in the build
   environment.
1. `ocix bash`: Run an interactive shell in the build environment.

Note that commands are executed verbatim. If any shell processing for
environment variable expansion or redirection is required, please use
`bash -c 'command args...'`.

## Usage

For the impatient, here's how to compile a hello world for `arm64` using Podman:

```bash
cd ~/src/your-project
podman run --rm ocix/linux-arm64 > ~/.local/share/bin/ocix-linux-arm64
chmod +x ~/.local/share/bin/ocix-linux-arm64
./ocix-linux-arm64 bash -c '$CC test/C/hello.c -o hello_arm'
```

Note how invoking any toolchain command (make, gcc, etc.) is just a matter of
prepending the **ocix** script on the commandline:

```bash
./ocix-linux-arm64 [command] [args...]
```

The **ocix** script will select between the docker and podman container engines,
then execute the given command-line inside the container, along with all
arguments passed after the command. 
If podman is installed and responds to `command -v podman` it is selected.
Otherwise, the default container engine executable is `docker`.

Commands that evaluate environmental variables in the image, like `${CC}` above,
should be executed in `bash -c 'some cmds'`.
The present working directory is mounted within the image, which can be used to
make source code available in the container.

## Cross compilers

> target
>
> :   <https://microbadger.com/images/dockcross/ocix-base>
>
dockcross/ocix-base

:

    ![base-images](https://images.microbadger.com/badges/image/dockcross/ocix-base.svg) Base image for other toolchain images. From Debian 10 (Buster)

    :   with GCC, make, autotools, CMake, Ninja, Git, and Python.

    target

    :   <https://microbadger.com/images/dockcross/ocix-android-arm>

dockcross/ocix-android-arm

:   ![android-arm-images](https://images.microbadger.com/badges/image/dockcross/ocix-android-arm.svg) The Android NDK standalone toolchain for the arm architecture.

<!-- -->

dockcross/ocix-android-arm64

:   |android-arm64-images| The Android NDK standalone toolchain for the arm64 architecture.

<!-- -->

dockcross/ocix-linux-arm64

:   |linux-arm64-images| Cross compiler for the 64-bit ARM platform on Linux, also known as AArch64.

<!-- -->

dockcross/ocix-linux-armv5

:   |linux-armv5-images| Linux armv5 cross compiler toolchain for legacy devices like the Parrot AR Drone.

<!-- -->

dockcross/ocix-linux-armv5-musl

:   |linux-armv5-musl-images| Linux armv5 cross compiler toolchain using [musl](https://www.musl-libc.org/) as base "libc".

<!-- -->

dockcross/ocix-linux-armv6

:   |linux-armv6-images| Linux ARMv6 cross compiler toolchain for the Raspberry Pi, etc.

<!-- -->

dockcross/ocix-linux-armv7

:   |linux-armv7-images| Generic Linux armv7 cross compiler toolchain.

<!-- -->

dockcross/ocix-linux-armv7a

:   |linux-armv7a-images| Toolchain configured for ARMv7-A used in Beaglebone Black single board PC with TI SoC AM3358 on board, Cortex-A8.

    target

    :   <https://microbadger.com/images/dockcross/ocix-linux-mipsel>

dockcross/ocix-linux-mipsel

:   ![linux-mipsel-images](https://images.microbadger.com/badges/image/dockcross/ocix-linux-mipsel.svg) Linux mipsel cross compiler toolchain for little endian MIPS GNU systems.

    target

    :   <https://microbadger.com/images/dockcross/ocix-linux-mips>

dockcross/ocix-linux-mips

:   ![linux-mips-images](https://images.microbadger.com/badges/image/dockcross/ocix-linux-mips.svg) Linux mips cross compiler toolchain for big endian 32-bit hard float MIPS GNU systems.

    target

    :   <https://microbadger.com/images/dockcross/ocix-linux-s390x>

dockcross/ocix-linux-s390x

:   ![linux-s390x-images](https://images.microbadger.com/badges/image/dockcross/ocix-linux-s390x.svg) Linux s390x cross compiler toolchain for S390X GNU systems.

    target

    :   <https://microbadger.com/images/dockcross/ocix-linux-ppc64el>

dockcross/ocix-linux-ppc64el

:   ![linux-ppc64el-images](https://images.microbadger.com/badges/image/dockcross/ocix-linux-ppc64el.svg) Linux PowerPC 64 little endian cross compiler toolchain for the POWER8, etc.

<!-- -->

dockcross/ocix-linux-x64

:   |linux-x64-images| Linux x86_64 / amd64 compiler. Since the container image is natively x86_64, this is not actually a cross compiler.

<!-- -->

dockcross/ocix-linux-x86

:   |linux-x86-images| Linux i686 cross compiler.

<!-- -->

dockcross/ocix-manylinux2014-x64

:   |manylinux2014-x64-images| [manylinux2014](https://github.com/pypa/manylinux) container image for building Linux x86_64 / amd64 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX2014 to "TRUE" in the toolchain.

<!-- -->

dockcross/ocix-manylinux2010-x64

:   |manylinux2010-x64-images| [manylinux2010](https://github.com/pypa/manylinux) container image for building Linux x86_64 / amd64 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX2010 to "TRUE" in the toolchain.

<!-- -->

dockcross/ocix-manylinux2010-x86

:   |manylinux2010-x86-images| [manylinux2010](https://github.com/pypa/manylinux) container image for building Linux i686 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX2010 to "TRUE" in the toolchain.

<!-- -->

dockcross/ocix-manylinux1-x64

:   |manylinux1-x64-images| [manylinux1](https://github.com/pypa/manylinux/tree/manylinux1) container image for building Linux x86_64 / amd64 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX1 to "TRUE" in the toolchain.

<!-- -->

dockcross/ocix-manylinux1-x86

:   |manylinux1-x86-images| [manylinux1](https://github.com/pypa/manylinux/tree/manylinux1) container image for building Linux i686 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX1 to "TRUE" in the toolchain.

<!-- -->

dockcross/ocix-web-wasm

:   |web-wasm-images| The Emscripten WebAssembly/asm.js/JavaScript cross compiler.

<!-- -->

dockcross/ocix-windows-static-x64

:   |windows-static-x64-images| 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and static linking.

<!-- -->

dockcross/ocix-windows-static-x64-posix

:   |windows-static-x64-posix-images| 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with posix threads and static linking.

<!-- -->

dockcross/ocix-windows-static-x86

:   |windows-static-x86-images| 32-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and static linking.

    target

    :   <https://microbadger.com/images/dockcross/ocix-windows-shared-x64>

dockcross/ocix-windows-shared-x64

:   ![windows-shared-x64-images](https://images.microbadger.com/badges/image/dockcross/ocix-windows-shared-x64.svg) 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and dynamic linking.

<!-- -->

dockcross/ocix-windows-shared-x64-posix

:   |windows-shared-x64-posix-images| 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with posix threads and dynamic linking.

<!-- -->

dockcross/ocix-windows-shared-x86

:   |windows-shared-x86-images| 32-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and dynamic linking.

Articles
--------

-   [dockcross: C++ Write Once, Run Anywhere](https://nbviewer.jupyter.org/format/slides/github/dockcross/cxx-write-once-run-anywhere/blob/master/dockcross_CXX_Write_Once_Run_Anywhere.ipynb#/)

- [Cross-compiling binaries for multiple architectures with Docker](https://web.archive.org/web/20170912153531/http://blogs.nopcode.org/brainstorm/2016/07/26/cross-compiling-with-docker) Built-in update commands ------------------------

A special update command can be executed that will update the source cross-compiler container image or the ocix script itself.

- `ocix [--] command [args...]`: Forces a command to run inside the container (in case of a name clash with a built-in command), use `--` before the command.
- `ocix update-image`: Fetch the latest version of the container image.
- `ocix update-script`: Update the installed ocix script with the one bundled in the image.

- `ocix update`: Update both the container image, and the ocix script. Download all images -------------------

To easily download all images, the convenience target `display_images` could be used:

```bash
curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
for image in $(make -f ocix-Makefile display_images); do
  echo "Pulling ocix/$image"
  docker pull ocix/$image
done
```

For Podman users cut-and-paste:

    curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
    for image in $(make -f ocix-Makefile display_images); do
      echo "Pulling ocix/$image"
      podman pull ocix/$image
    done

Install all ocix scripts
------------------------

To automatically install in `~/bin` the ocix scripts for each images already downloaded, the convenience target `display_images` could be used:

    curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
    for image in $(make -f ocix-Makefile display_images); do
      if [[ $(docker images -q ocix/$image) == "" ]]; then
        echo "~/bin/ocix-$image skipping: image not found locally"
        continue
      fi
      echo "~/bin/ocix-$image ok"
      docker run ocix/$image > ~/bin/ocix-$image &&
      chmod u+x  ~/bin/ocix-$image
    done

For Podman users cut-and-paste:

    curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o ocix-Makefile
    for image in $(make -f ocix-Makefile display_images); do
      if [[ $(podman images -q ocix/$image) == "" ]]; then
        echo "~/bin/ocix-$image skipping: image not found locally"
        continue
      fi
      echo "~/bin/ocix-$image ok"
      podman run ocix/$image > ~/bin/ocix-$image &&
      chmod u+x  ~/bin/ocix-$image
    done

Dockcross configuration
-----------------------

The following environmental variables and command-line options are used. In all cases, the command-line option overrides the environment variable.

### OCIX_CONFIG / --config|-c <path-to-config-file>

This file is sourced, if it exists, before executing the rest of the ocix script.

Default: `~/.ocix`

### OCIX_IMAGE / --image|-i <container-image-name>

The cross-compiler container image to run.

Default: Image with which the script was created.

DOCKCROSS_ARGS / --args|-a <container-run-args> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Extra arguments to pass to the `docker run` or `podman run` command. Quote the entire set of args if they contain spaces. Per-project ocix configuration -----------------------------------

If a shell script named `.ocix` is found in the current directory where the ocix script is started, it is executed before the ocix script `command` argument. The shell script is expected to have a shebang like `#!/usr/bin/env bash`.

For example, commands like `git config --global advice.detachedHead false` can be added to this script. How to extend Dockcross images ------------------------------In order to extend Dockcross images with your own commands, one must:

1.  Use `FROM <registry>/<org_name>/<name_of_image>`.
2.  Set `DEFAULT_OCIX_IMAGE` to a name you're planning to use for the image. This name must then be used during the build phase, unless you mean to pass the resulting helper script the `OCIX_IMAGE` argument.

An example Dockerfile would be:

    FROM docker.io/dockcross/ocix-linux-armv7:2.0.0

    ENV DEFAULT_OCIX_IMAGE my_cool_image
    RUN apt-get install nano

And then in the shell:

    docker build -t my_cool_image .         # Builds the ocix image.
    docker run my_cool_image > linux-armv7  # Creates a helper script named linux-armv7.
    chmod +x linux-armv7                    # Gives the script execution permission.
    ./linux-armv7 bash                      # Runs the helper script with the argument "bash", which starts an interactive container using your extended image.

Self-Hosting
============

Some use cases require that all code and infrastructure be under the control of an organization (e.g. regulated industries). This code base aims to support such use cases. The following describes how to setup one pipeline and does not cover configuring Git server, CI/CD server, or OCI registry. The images created are prefixed with `ocix-*` to prevent clashes with existing container image names in your registry.

We welcome Pull-Requests adding support and instructions for other services.

GitHub + CircleCI + Docker.io/Quay.io
-------------------------------------

1.  Fork the repository `dockcross/dockcross` to `YourOrg/YourName`.
2.  Clone your fork to you local computer.
3.  Add your container registry name to the file `ocix_registry`. Example: If you use commands such as `docker login https://oci.example.com` and `docker pull oci.example.com/my-image`, then add `oci.example.com` to the file `ocix_registry`. Default: `docker.io`.
4.  Add your container registry port number to the file `ocix_port`. Default: `443`.
5.  If you wish to make these containers available from your container registry under the organization/user name `MyProject` (does not have to match the Git server organization/user) then add `MyProject` to the file `ocix_org`. Default: `dockcross`
6.  To build and upload a single container: `make ocix-linux-arm64`. To see a list of containers available: `make list`.
7.  To build and upload all containers: Add the git repository to you CircleCI account. Then:
    a.  Select CircleCI Project settings.
    b.  Select Environment variables.
    c.  Add `OCIX_REGISTRY_USER` with your OCI registry user name.
    d.  Add `OCIX_REGISTRY_PASSWORD` with your OCI registry password.

What is the difference between dockcross and dockbuild ?
--------------------------------------------------------

The key difference is that [dockbuild](https://github.com/dockbuild/dockbuild#readme) images do **NOT** provide a [toolchain file](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html) but they use the same method to conveniently isolate the build environment as [dockcross](https://github.com/dockcross/dockcross#readme).

dockbuild is used to build binaries for Linux x86_64 / amd64 that will work across most Linux distributions. dockbuild performs a native Linux build where the host build system is a Linux x86_64 / amd64 container image (so that it can be used for building binaries on any system which can run Open Container Initiative compatible container images) and the target runtime system is Linux x86_x64 / amd64.

ocix is used to build binaries for many different platforms. ocix performs a cross compilation where the host build system is a Linux x86_64 / amd64 container image (so that it can be used for building binaries on any system which can run Open Container Initiative compatible container images) and the target runtime system varies. ---

Credits go to [sdt/docker-raspberry-pi-cross-compiler](https://github.com/sdt/docker-raspberry-pi-cross-compiler), who invented the base of the **dockcross** script.
