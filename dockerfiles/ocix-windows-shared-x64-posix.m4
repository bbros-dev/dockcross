include(shared/base.m4)

ENV WINEARCH win64
ARG MXE_TARGET_ARCH=x86_64
ARG MXE_TARGET_THREAD=.posix
ARG MXE_TARGET_LINK=shared

include(shared/windows.m4)

include(shared/aptitude-env.m4)

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
