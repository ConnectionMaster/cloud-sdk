#------------------------------------------------------------------------------
# Base image:
#------------------------------------------------------------------------------

FROM alpine:3.6

#------------------------------------------------------------------------------
# Build-time arguments:
#------------------------------------------------------------------------------

ARG CLOUD_SDK_VERSION="169.0.0"
ARG DOCKER_VERSION="17.06.2-ce"
ARG HELM_VERSION="2.6.1"
ARG HRP_VERSION="0.7.0"
ARG APPR_VERSION="0.7.3"

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV PATH="/google-cloud-sdk/bin:${PATH}" \
    SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads" \
    DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
    HELM_URL="https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get" \
    HRP_URL="https://github.com/app-registry/appr-helm-plugin/releases/download/v${HRP_VERSION}"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

RUN apk --no-cache add -U curl python py-crcmod bash libc6-compat git \
    jq openssl openssh-client \
    && curl -OL ${SDK_URL}/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && tar zxf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && curl -fL ${DOCKER_URL} | tar zx -C /usr/local/bin --strip-components 1 \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud -q components install kubectl \
    && curl -s ${HELM_URL} | DESIRED_VERSION="v${HELM_VERSION}" bash \
    && curl -OL ${HRP_URL}/helm-registry_linux.tar.gz && mkdir -p ~/.helm/plugins \
    && tar zxf helm-registry_linux.tar.gz -C ~/.helm/plugins \
    && helm registry upgrade-plugin v${APPR_VERSION} \
    && rm -f *.gz /var/cache/apk/*
