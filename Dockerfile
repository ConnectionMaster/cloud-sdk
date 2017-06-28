#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM alpine:3.6
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Build-time arguments:
#------------------------------------------------------------------------------

ARG CLOUD_SDK_VERSION="159.0.0"
ARG CLOUD_SDK_SHA256SUM="5b408575407514f99ad913bd0c6991be4b46408ddc7080a6494bbf43e6ce222a"
ARG HRP_VERSION="0.4.1"

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV PATH="/google-cloud-sdk/bin:${PATH}" \
    SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads" \
    HELM_URL="https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get" \
    HRP_URL="https://github.com/app-registry/appr-helm-plugin/releases/download/v${HRP_VERSION}"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

RUN apk --no-cache add -U curl python py-crcmod bash libc6-compat git openssl \
    jq openssh-client && apk --no-cache add -U -t dev py2-pip \
    && curl -OL ${SDK_URL}/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && echo "${CLOUD_SDK_SHA256SUM}  google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
    > google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 \
    && sha256sum -c google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 \
    && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && rm -f google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.* \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud -q components install kubectl \
    && curl -s ${HELM_URL} | sed 's/\<sudo\>//g' | bash \
    && curl -OL ${HRP_URL}/registry-helm-plugin.tar.gz && mkdir -p ~/.helm/plugins \
    && tar xzvf registry-helm-plugin.tar.gz -C ~/.helm/plugins \
    && rm -f ~/.helm/plugins/registry/cnr && pip install cnr==${HRP_VERSION} \
    && ln -s $(which cnr) ~/.helm/plugins/registry/cnr \
    && apk del --purge dev && rm -f *.gz /var/cache/apk/*
