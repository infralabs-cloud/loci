ARG FROM=ubuntu:jammy
FROM ${FROM}

ENV DEBIAN_FRONTEND=noninteractive

# Install Ubuntu keyrings first to avoid NO_PUBKEY errors
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    ubuntu-keyring \
    curl \
    gnupg2 \
    lsb-release

# Add Ceph Reef repo
RUN curl -fsSL https://download.ceph.com/keys/release.asc | gpg --dearmor -o /usr/share/keyrings/ceph.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/ceph.gpg] https://download.ceph.com/debian-reef jammy main" > /etc/apt/sources.list.d/ceph.list

RUN apt-get update && \
    apt-get install -y iptables arptables ebtables ceph-common && \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
    update-alternatives --set arptables /usr/sbin/arptables-legacy && \
    update-alternatives --set ebtables /usr/sbin/ebtables-legacy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD [ "bash" ]