# Start include from shared/manylinux.m4
#

include(shared/aptitude-env.m4)
include(shared/sshd-privilege-separation.m4)

# Image build scripts
COPY scripts/install-gosu-binary.sh \
     scripts/install-gosu-binary-wrapper.sh \
     scripts/install-python-packages-manylinux.sh \
     /buildscripts/

RUN set -x && \
    yum -y install \
        epel-release \
        gpg \
        zlib-devel \
        gettext \
        openssh-clients \
        pax \
        wget \
        zip  && \
  yum clean all && \
  /buildscripts/install-gosu-binary.sh && \
  /buildscripts/install-gosu-binary-wrapper.sh && \
  # Remove sudo provided by "devtoolset-2" and "devtoolset-8" since it doesn't work with
  # our sudo wrapper calling gosu.
  rm -f /opt/rh/devtoolset-2/root/usr/bin/sudo && \
  rm -f /opt/rh/devtoolset-7/root/usr/bin/sudo && \
  rm -f /opt/rh/devtoolset-8/root/usr/bin/sudo && \
  /buildscripts/install-python-packages-manylinux.sh && \
  rm -rf /buildscripts

# Runtime scripts
COPY scripts/pre-exec-manylinux.sh /ocix/pre_exec.sh

#
# End include from shared/manylinux.m4
