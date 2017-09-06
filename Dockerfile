#------------------------------------------------------------------------------
# Base image:
#------------------------------------------------------------------------------

FROM alpine:3.6

#------------------------------------------------------------------------------
# Build-time arguments:
#------------------------------------------------------------------------------

ARG SDK_VERSION="169.0.0"
ARG DOCKER_VERSION="17.06.2-ce"
ARG HELM_VERSION="2.6.1"
ARG HRP_VERSION="0.7.0"
ARG APPR_VERSION="0.7.3"

#------------------------------------------------------------------------------
# Persistent environment variables:
#------------------------------------------------------------------------------

ENV PATH="/google-cloud-sdk/bin:${PATH}"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

RUN SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${SDK_VERSION}-linux-x86_64.tar.gz"; \
    DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz"; \
    HELM_URL="https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get"; \
    HRP_URL="https://github.com/app-registry/appr-helm-plugin/releases/download/v${HRP_VERSION}/helm-registry_linux.tar.gz"; \
\
    apk --no-cache add -U curl python py-crcmod bash libc6-compat git jq openssl openssh-client \
    && curl -L ${SDK_URL} | tar zx && mkdir -p ~/.helm/plugins \
    && curl -L ${DOCKER_URL} | tar zx -C /usr/local/bin --strip-components 1 \
    && curl -L ${HRP_URL} | tar zx -C ~/.helm/plugins \
    && curl -L ${HELM_URL} | DESIRED_VERSION="v${HELM_VERSION}" bash \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud -q components install kubectl \
    && helm registry upgrade-plugin v${APPR_VERSION} \
    && rm -f *.gz /var/cache/apk/*
