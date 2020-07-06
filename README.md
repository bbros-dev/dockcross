# OCIX

[Self hostable](#self-hosting) cross compile toolchains in [OCI][oci] images.

[![Master](https://circleci.com/gh/begleybrothers/ocix.svg?style=svg)](https://app.circleci.com/pipelines/github/begleybrothers/ocix?branch=master "Released Images")
[![Development](https://circleci.com/gh/bbros-dev/ocix/tree/develop.svg?style=svg)](https://app.circleci.com/pipelines/github/bbros-dev/ocix?branch=develop "Development Images")

## TL;DR

We welcome PRs adding other OCI registries and CI providers.

1. Update the TLD files `ocix_version`, `ocix_org`, `ocix_registry`,
   `ocix_api_server`, `ocix_port`.
1. In Circle CI:
    * Add `OCIX_REGISTRY_USER` with your OCI registry user name.
    * Add `OCIX_REGISTRY_PASSWORD` with your OCI registry password.
1. `git add .; git commit -m "Deployed if built on CircleCI";` . 

## Features

- Supports [Docker](https://www.docker.com/) and [Podman](https://podman.io/)
  OCI container engines at build-time and at runtime.
- Supports [Open Container Initiative (OCI)][oci] compatible containers and
  registries, docker.io, quay.io, etc.
- Supports use cases where code and containers must be self-hosted. See
  Self-Hosting below. To see a list of containers available: `make list`.
- Supports single container use cases where this project may be a
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
IMAGE_SLUG=yelgeb/ocix-linux-x64:2.0.0
docker run --rm ${IMAGE_SLUG} > ~/.local/share/bin/ocix
chmod a+x ~/.local/share/bin/ocix
```

Podman users can replace docker with podman in all documentation examples:

```bash
IMAGE_SLUG=yelgeb/ocix-linux-x64:2.0.0
podman run --rm ${IMAGE_SLUG} > ~/.local/share/bin/ocix
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

## Self-Hosting

Some use cases require that all code and infrastructure be under the control
of an organization (e.g. regulated industries).
This code base supports such use cases.
The following describes how to setup one pipeline and does not cover
configuring Git server, CI/CD server, or OCI registry.
The images created are prefixed with `ocix-*` to prevent clashes with existing
container image names in your registry.

We welcome Pull-Requests adding support and instructions for other services.

## GitHub + CircleCI + Docker.io

1. Fork the repository `BegleyBrothers/ocix` to `YourOrg/YourName`.
1. Clone your fork to you local computer.
1. Add your container registry name to the file `ocix_registry`.
   Example: If you use commands such as `docker login https://oci.example.com` and `docker pull oci.example.com/my-image`, then add `oci.example.com` to the file `ocix_registry`. Default: `docker.io`.
1. Add your container registry port number to the file `ocix_port`.
   Default: `443`.
1. If you wish to make these containers available from your container
   registry under the organization/user name `MyProject` (does not have to match the Git server organization/user) then add `MyProject` to the file `ocix_org`. Default: `dockcross`
1. To build and upload a single container: `make ocix-linux-arm64`.
   To see a list of containers available: `make list`.
1. To build and upload all containers: Add the git repository to you
   CircleCI account. Then:
    a.  Select CircleCI Project settings.
    b.  Select Environment variables.
    c.  Add `OCIX_REGISTRY_USER` with your OCI registry user name.
    d.  Add `OCIX_REGISTRY_PASSWORD` with your OCI registry password.

## OCIX Usage

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
> :   <https://microbadger.com/imagesBelgeyBrothers/ocix-base>
>
dockcross/ocix-base

:

    ![base-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-base.svg) Base image for other toolchain images. From Debian 10 (Buster)

    :   with GCC, make, autotools, CMake, Ninja, Git, and Python.

    target

    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-android-arm>

dockcross/ocix-android-arm

:   ![android-arm-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-android-arm.svg) The Android NDK standalone toolchain for the arm architecture.

<!-- -->

dockcross/ocix-android-arm64

:   |android-arm64-images| The Android NDK standalone toolchain for the arm64 architecture.


    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-linux-mipsel>

dockcross/ocix-linux-mipsel

:   ![linux-mipsel-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-linux-mipsel.svg) Linux mipsel cross compiler toolchain for little endian MIPS GNU systems.

    target

    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-linux-mips>

dockcross/ocix-linux-mips

:   ![linux-mips-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-linux-mips.svg) Linux mips cross compiler toolchain for big endian 32-bit hard float MIPS GNU systems.

    target

    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-linux-s390x>

dockcross/ocix-linux-s390x

:   ![linux-s390x-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-linux-s390x.svg) Linux s390x cross compiler toolchain for S390X GNU systems.

    target

    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-linux-ppc64el>

dockcross/ocix-linux-ppc64el

:   ![linux-ppc64el-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-linux-ppc64el.svg) Linux PowerPC 64 little endian cross compiler toolchain for the POWER8, etc.

[![ocix-linux-arm64][ocix-linux-arm64]](https://microbadger.com/images/yelgeb/ocix-linux-arm64 "Metadata")
Cross compiler for the 64-bit ARM platform on Linux, also known as AArch64.

[![ocix-linux-x64][ocix-linux-x64]](https://microbadger.com/images/yelgeb/ocix-linux-x64 "Metadata")
[![ocix-linux-x86][ocix-linux-x86]](https://microbadger.com/images/yelgeb/ocix-linux-x86 "Metadata")

[![ocix-manylinux2010-x64][ocix-manylinux2010-x64]](https://microbadger.com/images/yelgeb/ocix-manylinux2010-x64 "Metadata")
OCI image for building Linux `x86_64/amd64`
[Python wheel packages](http://pythonwheels.com/).
It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8.
Also has support for the dockcross script, and it has installations of CMake,
Ninja, and [scikit-build](http://scikit-build.org).
For CMake, it sets MANYLINUX2014 to "TRUE" in the toolchain.

[![ocix-manylinux2010-x86][ocix-manylinux2010-x86]](https://microbadger.com/images/yelgeb/ocix-manylinux2010-x86 "Metadata")
OCI image for building Linux i686 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX2010 to "TRUE" in the toolchain.

[![ocix-manylinux2014-x64][ocix-manylinux2014-x64]](https://microbadger.com/images/yelgeb/ocix-manylinux2014-x64 "Metadata")

[ocix-linux-arm64]: https://images.microbadger.com/badges/image/yelgeb/ocix-linux-arm64.svg "OCIX Linux ARM64"
[ocix-linux-x64]: https://images.microbadger.com/badges/image/yelgeb/ocix-linux-x64.svg "OCIX Linux X86_64"
[ocix-linux-x86]: https://images.microbadger.com/badges/image/yelgeb/ocix-linux-x86.svg "OCIX Linux X86"
[ocix-manylinux2010-x64]: https://images.microbadger.com/badges/image/yelgeb/ocix-manylinux2010-x64.svg "OCIX ManyLinux-2010 X64"
[ocix-manylinux2010-x86]: https://images.microbadger.com/badges/image/yelgeb/ocix-manylinux2010-x86.svg "OCIX ManyLinux-2010 X86"
[ocix-manylinux2014-x64]: https://images.microbadger.com/badges/image/yelgeb/ocix-manylinux2014-x64.svg "OCIX ManyLinux-2014 X64"

dockcross/ocix-manylinux2010-x64

:   |manylinux2010-x64-images| [manylinux2010](https://github.com/pypa/manylinux) container image for building Linux x86_64 / amd64 [Python wheel packages](http://pythonwheels.com/). It includes Python 2.7, 3.4, 3.5, 3.6, 3.7 and 3.8. Also has support for the dockcross script, and it has installations of CMake, Ninja, and [scikit-build](http://scikit-build.org). For CMake, it sets MANYLINUX2010 to "TRUE" in the toolchain.

<!-- -->

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

    :   <https://microbadger.com/imagesBelgeyBrothers/ocix-windows-shared-x64>

dockcross/ocix-windows-shared-x64

:   ![windows-shared-x64-images](https://images.microbadger.com/badges/imageBelgeyBrothers/ocix-windows-shared-x64.svg) 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and dynamic linking.

<!-- -->

dockcross/ocix-windows-shared-x64-posix

:   |windows-shared-x64-posix-images| 64-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with posix threads and dynamic linking.

<!-- -->

dockcross/ocix-windows-shared-x86

:   |windows-shared-x86-images| 32-bit Windows cross-compiler based on [MXE/MinGW-w64](https://mxe.cc/) with win32 threads and dynamic linking.

## Articles

- [dockcross: C++ Write Once, Run Anywhere](https://nbviewer.jupyter.org/format/slides/github/dockcross/cxx-write-once-run-anywhere/blob/master/dockcross_CXX_Write_Once_Run_Anywhere.ipynb#/)

- [Cross-compiling binaries for multiple architectures with Docker](https://web.archive.org/web/20170912153531/http://blogs.nopcode.org/brainstorm/2016/07/26/cross-compiling-with-docker) Built-in update commands ------------------------

A special update command can be executed that will update the source cross-compiler container image or the ocix script itself.

- `ocix-<flavor> [--] command [args...]`: Forces a command to run inside the
  container (in case of a name clash with a built-in command), use `--` before
   the command.
- `ocix-<flavor> update-image`: Fetch the latest version of the container image.
- `ocix-<flavor> update-script`: Update the installed ocix script with the one
  bundled in the image.
- `ocix-<flavor> update`: Update both the container image, and the ocix script.
  Download all images

To easily download all images, the convenience target `list_images` could be used:

```bash
curl https://raw.githubusercontent.com/BegleyBrothers/ocix/master/Makefile -o Makefile
for image in $(make -f Makefile list_images); do
  echo "Pulling ocix/$image"
  docker pull ocix/$image
done
```

For Podman users cut-and-paste:

```bash
curl https://raw.githubusercontent.com/BegleyBrothers/ocix/master/Makefile \
     --output Makefile
for image in $(make -f Makefile list_images); do
  echo "Pulling ocix/$image"
  podman pull ocix/$image
done
```

## Install all ocix scripts

To automatically install in `~/.local/share/bin` the ocix scripts for each
images already downloaded, the convenience target `list_images` could
be used:

```bash
curl https://raw.githubusercontent.com/BegleyBrothers/ocix/master/Makefile \
     --output Makefile
for image in $(make -f Makefile list_images); do
  if [[ $(docker images -q ocix-$image:1.0.0) == "" ]]; then
    echo "~/.local/share/bin/ocix-$image skipping: image not found locally"
    continue
  fi
  echo "~/.local/share/bin/ocix-$image ok"
  docker run ocix-$image:1.0.0 > ~/.local/share/bin/ocix-$image &&
  chmod u+x  ~/.local/share/bin/ocix-$image
done
```

For Podman users cut-and-paste:

```bash
curl https://raw.githubusercontent.com/BegleyBrothers/ocix/master/Makefile \
     --output Makefile
for image in $(make -f Makefile list_images); do
  if [[ $(podman images -q ocix-$image:1.0.0) == "" ]]; then
    echo "~/.local/share/bin/ocix-$image skipping: image not found locally"
    continue
  fi
  echo "~/.local/share/bin/ocix-$image ok"
  podman run ocix-$image > ~/.local/share/bin/ocix-$image &&
  chmod u+x  ~/.local/share/bin/ocix-$image
done
```

## OCIX configuration

The following environmental variables and command-line options are used. In all cases, the command-line option overrides the environment variable.

### OCIX_CONFIG / --config|-c <path-to-config-file>

This file is sourced, if it exists, before executing the rest of the ocix script.

Default: `~/.config/ocix`

### OCIX_IMAGE / --image|-i <container-image-name>

The cross-compiler container image to run.

Default: Image with which the script was created.

### OCIX_ARGS / --args|-a <container-run-args>

Extra arguments to pass to the `docker run` or `podman run` command. Quote the entire set of args if they contain spaces.

## Per-project ocix configuration

If a shell script named `.ocix` is found in the current directory where the ocix script is started, it is executed before the ocix script `command` argument. The shell script is expected to have a shebang like `#!/usr/bin/env bash`.

For example, commands like `git config --global advice.detachedHead false` can be added to this script.

### How to extend OCIX images

In order to extend OCIX images with your own commands, one must:

1. Use `FROM <registry>/<org_name>/<name_of_image>`.
2. Set `DEFAULT_OCIX_IMAGE` to a name you're planning to use for the image. This name must then be used during the build phase, unless you mean to pass the resulting helper script the `OCIX_IMAGE` argument.

An example Dockerfile would be:

```bash
    FROM docker.io/yelgeb/ocix-linux-arm64:2.0.0

    ENV DEFAULT_OCIX_IMAGE my_org/my_image:1.0.0
    RUN apt-get install nano
```

And then in the shell:

```bash
IMAGE_SLUG=my_org/my_image:1.0.0
docker build -t ${IMAGE_SLUG} .   # Builds the ocix image.
docker run my_image > linux-arm64 # Create helper script `linux-arm64`.
chmod +x linux-arm64              # Make the script executable.
./linux-arm64 bash                # Run the helper script with the argument
                                  # `bash` - starts an interactive
                                  # container using your extended image.
```

## The difference between OCIX and dockcross

The key difference is that [dockcross](https://github.com/BegleyBrothers/ocix#readme)
does not **not** encourage self-hosting of one or all build containers.
Dockcross image names e.g. `linux-arm64` will conflict for any organization/user
that has a similarly named container.  Some other differences:

- OCIX is based on Debian 10 (Buster).
- ARM users other than `ARM64` are encouraged to use the
  [Yocto project](https:www.yoctoproject.org)
  build infrastructure for [ARM boards and devices][yarm])

## The difference between dockcross and dockbuild

The key difference is that [dockbuild](https://github.com/dockbuild/dockbuild#readme)
images do **NOT** provide a [toolchain file](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html)
but they use the same method to conveniently isolate the build environment as
[dockcross](https://github.com/dockcross/dockcross#readme).

The `dockbuild` images are used to build binaries for Linux `x86_64/amd64` that
work across most Linux distributions.
`dockbuild` performs a native Linux build where the host build system is a Linux
`x86_64/amd64` container image (so that it can be used for building binaries on
any system which can run container images) and the target runtime system is
Linux `x86_x64/amd64`.

dockcross is used to build binaries for many different platforms.
dockcross performs a cross compilation where the host build system is a Linux
`x86_64/amd64` container image (so that it can be used for building binaries on
any system which can run container images) and the target runtime system varies.

Credits go to [sdt/docker-raspberry-pi-cross-compiler][rpi], who invented the
base of the **dockbuild** script.

[oci]: https://www.opencontainers.org/
[rpi]: https://github.com/sdt/docker-raspberry-pi-cross-compiler
[yarm]: https://git.yoctoproject.org/cgit.cgi/poky/plain/meta/conf/machine/include/arm
