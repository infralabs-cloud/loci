#!/bin/bash

set -xeo pipefail

source "$(dirname $0)/helpers.sh"

export LC_CTYPE=C.UTF-8
export DEBIAN_FRONTEND=noninteractive

cat <<EOF >> /etc/apt/apt.conf.d/allow-unathenticated
APT::Get::AllowUnauthenticated "${ALLOW_UNAUTHENTICATED}";
Acquire::AllowInsecureRepositories "${ALLOW_UNAUTHENTICATED}";
Acquire::AllowDowngradeToInsecureRepositories "${ALLOW_UNAUTHENTICATED}";
EOF

apt-get update
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    lsb-release \
    wget

configure_apt_sources "${APT_MIRROR}"

# Add OpenStack UCA repo if OPENSTACK_RELEASE is provided
if [ -n "$OPENSTACK_RELEASE" ]; then
    echo "Adding OpenStack UCA repository for $OPENSTACK_RELEASE"
    apt-get update
    apt-get install -y --no-install-recommends software-properties-common
    add-apt-repository -y "cloud-archive:$OPENSTACK_RELEASE"
fi

# Add Ceph repo logic
CODENAME=$(lsb_release -sc)
if [[ "$CODENAME" == "noble" ]] && [[ "$CEPH_RELEASE" == "squid" ]]; then
    echo "Skipping Ceph repository addition for Squid on Noble (natively available)."
elif [ -n "${CEPH_REPO}" ]; then
    echo "Adding explicit Ceph repository: ${CEPH_REPO}"
    wget -q -O- "${CEPH_KEY}" | apt-key add -
    echo "${CEPH_REPO}" | tee /etc/apt/sources.list.d/ceph.list
elif [ -n "${CEPH_RELEASE}" ]; then
    echo "Adding Ceph repository for release: ${CEPH_RELEASE}"
    wget -q -O- "${CEPH_KEY}" | apt-key add -
    # Fallback for reef on noble
    REPO_CODENAME=$CODENAME
    if [[ "$CODENAME" == "noble" ]] && [[ "$CEPH_RELEASE" == "reef" ]]; then
        REPO_CODENAME="jammy"
    fi
    echo "deb https://download.ceph.com/debian-${CEPH_RELEASE} $REPO_CODENAME main" | tee /etc/apt/sources.list.d/ceph.list
fi

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
    git \
    netbase \
    patch \
    sudo \
    bind9-host \
    python3 \
    python3-venv

if [[ -n $(apt-cache search ^python3-distutils$ 2>/dev/null) ]]; then
    apt-get install -y --no-install-recommends python3-distutils
fi

apt-get install -y --no-install-recommends \
    libpython3.$(python3 -c 'import sys; print(sys.version_info.minor);')

revert_apt_sources

apt-get clean
rm -rf /var/lib/apt/lists/*
