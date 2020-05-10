include(shared/base.m4)

include(shared/aptitude.m4)

include(shared/environment.m4)

ENV WINEARCH win32
ARG MXE_TARGET_ARCH=i686
ARG MXE_TARGET_THREAD=
ARG MXE_TARGET_LINK=shared

include(shared/windows.m4)

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work
