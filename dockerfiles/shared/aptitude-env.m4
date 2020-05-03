# Start include from shared/aptitude-env.m4
#

ARG OCIX_IMAGE=${OCIX_IMAGE}
ARG OCIX_NAME=${OCIX_NAME}
ARG OCIX_ORG=${OCIX_ORG}
ARG OCIX_VERSION=${OCIX_VERSION}

ENV DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION}

RUN echo -e "#!/usr/bin/env bash \n\
OCIX_IMAGE=${OCIX_IMAGE} \n\
OCIX_NAME=${OCIX_NAME} \n\
OCIX_ORG=${OCIX_ORG} \n\
OCIX_VERSION=${OCIX_VERSION} \n\
DEFAULT_OCIX_IMAGE=${OCIX_NAME}:${OCIX_VERSION} \n " \
>> /etc/profile.d/00-ocix-env.sh && \
  chmod a+x /etc/profile.d/00-ocix-env.sh && \
  mkdir -p /etc/apt/apt.conf.d && \
  echo -e " \n\
Aptitude { \n\
  ProblemResolver { \n\
    SolutionCost "100*canceled-actions,200*removals"; \n\
  }; \n\
}; \n " \
>> /etc/apt/apt.conf.d/00-resolver && \
  chmod +x /etc/apt/apt.conf.d/00-resolver

#
# End include from shared/aptitude-env.m4
