include(shared/base.m4)
ENV WINEARCH win64
ARG MXE_TARGET_ARCH=x86_64
ARG MXE_TARGET_THREAD=
ARG MXE_TARGET_LINK=shared

include(shared/windows.m4)

include(shared/label.m4)

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
