# Build Helm Container
FROM geoffh1977/alpine:latest
LABEL maintainer="geoffh1977 <geoffh1977@gmail.com>"
USER root

ENV HELM_VERSION=2.13.1 \
    HELM_SHA=c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a

# Install Helm
# hadolint ignore=DL3018, DL4006
RUN apk add --no-cache ca-certificates && \
  wget -q -O /tmp/helm.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
  echo "${HELM_SHA}  /tmp/helm.tar.gz" | sha256sum -c - && \
  tar -zxf /tmp/helm.tar.gz -C /tmp linux-amd64/helm && \
  mv /tmp/linux-amd64/helm /usr/bin/helm && \
  rm -rf /tmp/helm.tar.gz /tmp/linux-amd64 && \
  mkdir -p /config /project && \
  chmod 0755 /usr/bin/helm && \
  chown "${ALPINE_USER}":"${ALPINE_USER}" /config /project

ENV HOME=/config

VOLUME ["/project"]
USER ${ALPINE_USER}
WORKDIR /project
CMD ["/usr/bin/helm"]
