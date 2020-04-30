# Start include from shared/crosstool.m4
#
# Common Docker instructions to install "crosstool-ng" and build a full
# cross-compiler suite from a crosstool-ng configuration, CROSSTOOL_CONFIG.
#
# This import complements the "ocix-base" image, adding:
# - "ct-ng", a cross-compiler building utilty.
# - A cross-compiler suite configured in "crosstool-ng.config".
#
# The generated cross-compiler will have a CROSS_ROOT of:
#   ${XCC_PREFIX}/${CROSS_TRIPLE}
#
# A given platform will need to supply the appropriate "crosstool-ng.config" to
# generate its cross-compiler. This can be built using "ct-ng menuconfig" to
# generate a configuration.

# Install Debian packages required for $(ct-ng).
RUN aptitude -f --no-gui -q -y --without-recommends install \
                      gawk \
                      gperf \
                      help2man \
                      libtool \
                      python-dev \
                      texinfo \
                      unzip && \
    aptitude -f --no-gui -q -y clean && \
    mkdir -p /ocix/crosstool

ENV XCC_PREFIX=/usr/xcc

# Add the crosstool-ng script and image-specific toolchain configuration into
# /ocix/.
#
# Afterwards, we will leave the "ct-ng" config in the image as a reference
# for users.
COPY scripts/install-crosstool-ng-toolchain.sh \
     crosstool-ng.config \
     /ocix/

# Build and install the toolchain, cleaning up artifacts afterwards.
WORKDIR /ocix/crosstool
RUN /ocix/install-crosstool-ng-toolchain.sh -p "${XCC_PREFIX}" \
                                            -c /ocix/crosstool-ng.config && \
    rm -rf /ocix/crosstool /ocix/install-crosstool-ng-toolchain.sh

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work

#
# End include from shared/crosstool.m4
