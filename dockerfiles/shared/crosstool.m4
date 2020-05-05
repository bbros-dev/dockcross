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

# -o Aptitude::ProblemResolver::SolutionCost='100*canceled-actions,200*removals'
# 
# Derived from [the manual](https://www.debian.org/doc/manuals/aptitude/ch02s03s04.en.html)
# Increase relative costs of solutions aptitude will use:
# 
# 1. Do not keep, if you can install or upgrade (by increasing canceled-actions counter)
# 2. Increase removals counter, because we want keep packages if aptitude decide to delete it

include(shared/aptitude-env.m4)
include(shared/sshd-privilege-separation.m4)

# Install Debian packages required for $(ct-ng).
#    aptitude -f --no-gui -q -y --without-recommends install \
#              gawk \
#              gperf \
#              help2man \
#              python3-dev \
#              unzip && \
#    aptitude -f --no-gui -q -y clean && \
RUN mkdir -p /ocix/crosstool && \
    aptitude -f --no-gui -q -y --without-recommends install \
              autoconf \
              automake \
              bison \
              bzip2 \
              flex \
              g++ \
              gawk \
              gcc \
              gperf \
              help2man \
              libncurses5-dev \
              libstdc++6 \
              libtool \
              libtool-bin \
              make \
              patch \
              python3-dev \
              rsync \
              texinfo \
              unzip \
              wget \
              xz-utils
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
                                            -c /ocix/crosstool-ng.config | \
                                            tee --append /work/crosstool.log && \
    rm -rf /ocix/crosstool /ocix/install-crosstool-ng-toolchain.sh

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work

#
# End include from shared/crosstool.m4
