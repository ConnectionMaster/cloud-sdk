#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM alpine:3.6
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Build-time arguments:
#------------------------------------------------------------------------------

ARG CLOUD_SDK_VERSION=156.0.0
ARG SHA256SUM=f47f41e7c389301dfee4879d6eb71d36c7b06aaf43a2be49a9ea39749be22851

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV PATH="/google-cloud-sdk/bin:${PATH}" \
    SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads" \
    HELM_URL="https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

RUN apk --no-cache add curl python py-crcmod bash libc6-compat git openssl ssh \
    && curl -O ${SDK_URL}/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && echo "${SHA256SUM}  google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
    > google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 \
    && sha256sum -c google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 \
    && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && ln -s /lib /lib64 && rm google-cloud-sdk-*-linux-x86_64* \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud -q components install kubectl \
    && curl -s ${HELM_URL} | sed 's/\<sudo\>//g' | bash
