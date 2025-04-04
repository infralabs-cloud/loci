ARG FROM=ubuntu:jammy
FROM ${FROM}

ARG CEPH_REPO="deb https://download.ceph.com/debian-reef/ jammy main"
ARG CEPH_KEY="https://download.ceph.com/keys/release.asc"
ARG ALLOW_UNAUTHENTICATED=false

RUN echo "APT::Get::AllowUnauthenticated \"${ALLOW_UNAUTHENTICATED}\";\n\
Acquire::AllowInsecureRepositories \"${ALLOW_UNAUTHENTICATED}\";\n\
Acquire::AllowDowngradeToInsecureRepositories \"${ALLOW_UNAUTHENTICATED}\";" \
    >> /etc/apt/apt.conf.d/allow-unathenticated

# Add Ubuntu keyring setup
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        wget && \
    mkdir -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/ubuntu-archive-keyring.gpg https://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb [signed-by=/etc/apt/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [signed-by=/etc/apt/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [signed-by=/etc/apt/keyrings/ubuntu-archive-keyring.gpg] http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        wget && \
    wget -q -O- ${CEPH_KEY} | apt-key add - && \
    echo "${CEPH_REPO}" | tee /etc/apt/sources.list.d/ceph.list && \
    apt-get remove -y wget gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
