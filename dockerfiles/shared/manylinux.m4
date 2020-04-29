# Start include from shared/manylinux.m4
#
# Image build scripts
COPY \
  scripts/install-gosu-binary.sh \
  scripts/install-gosu-binary-wrapper.sh \
  manylinux-common/install-python-packages.sh \
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
  PYTHON=$([ -e /opt/python/cp35-cp35m/bin/python ] && echo "/opt/python/cp35-cp35m/bin/python" || command -v python 2>/dev/null) && \
  /buildscripts/install-python-packages.sh && \
  rm -rf /buildscripts

# Runtime scripts
COPY manylinux-common/pre_exec.sh /ocix/

#
# End include from shared/manylinux.m4
