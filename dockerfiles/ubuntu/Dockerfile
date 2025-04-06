ARG FROM=ubuntu:jammy
FROM ${FROM}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release

# Add Ceph Reef repo
RUN curl -fsSL https://download.ceph.com/keys/release.asc | gpg --dearmor -o /usr/share/keyrings/ceph.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/ceph.gpg] https://download.ceph.com/debian-reef $(lsb_release -sc) main" > /etc/apt/sources.list.d/ceph.list

RUN apt-get update
