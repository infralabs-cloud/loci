ARG FROM=ubuntu:jammy
FROM --platform=$BUILDPLATFORM ${FROM}

ARG CEPH_REPO="deb [signed-by=/etc/apt/keyrings/ceph-keyring.gpg] https://download.ceph.com/debian-reef/ jammy main"
ARG CEPH_KEY="https://download.ceph.com/keys/release.asc"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    && rm -rf /var/lib/apt/lists/*


# Ceph repository setup
RUN export DEBIAN_FRONTEND=noninteractive && \
    wget -q -O- ${CEPH_KEY} | gpg --dearmor -o /etc/apt/keyrings/ceph-keyring.gpg && \
    echo "${CEPH_REPO}" | tee /etc/apt/sources.list.d/ceph.list && \
    apt-get remove -y wget gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
