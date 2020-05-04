#!/usr/bin/env bash
cat <<EOF >/etc/profile.d/00-ocix-env.sh
#!/usr/bin/env bash
OCIX_IMAGE=${OCIX_IMAGE}
OCIX_NAME=${OCIX_NAME}
OCIX_ORG=${OCIX_ORG}
OCIX_VERSION=${OCIX_VERSION}
DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}
EOF
chmod a+x /etc/profile.d/00-ocix-env.sh
