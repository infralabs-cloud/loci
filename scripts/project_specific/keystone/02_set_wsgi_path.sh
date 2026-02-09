#!/bin/bash
set -ex

# Ensure WSGI scripts are in /usr/local/bin for charts that expect them there
# Loci installs them in /var/lib/openstack/bin
echo "Searching for keystone WSGI scripts..."
find /var/lib/openstack -name "keystone-wsgi-*"

for script in keystone-wsgi-public keystone-wsgi-admin; do
    FOUND_PATH=$(find /var/lib/openstack -name "$script" | head -n 1)
    if [ -n "$FOUND_PATH" ]; then
        echo "Creating symlink for $script from $FOUND_PATH"
        ln -sf "$FOUND_PATH" "/usr/local/bin/$script"
        chmod +x "/usr/local/bin/$script"
    else
        echo "Warning: $script not found anywhere in /var/lib/openstack"
    fi
done

ls -l /usr/local/bin/keystone-wsgi-* || true
