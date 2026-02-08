#!/bin/bash
set -ex

# Ensure WSGI scripts are in /usr/local/bin for charts that expect them there
# Loci installs them in /var/lib/openstack/bin
for script in keystone-wsgi-public keystone-wsgi-admin; do
    if [ -f "/var/lib/openstack/bin/$script" ]; then
        echo "Creating symlink for $script"
        ln -sf "/var/lib/openstack/bin/$script" "/usr/local/bin/$script"
    else
        echo "Warning: $script not found in /var/lib/openstack/bin"
    fi
done
