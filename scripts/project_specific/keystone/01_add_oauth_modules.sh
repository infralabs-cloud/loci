#!/bin/bash

set -ex

if [[ ${distro} -eq "ubuntu" ]]; then
        apt-get install -y --no-install-recommends wget apache2  libapache2-mod-wsgi-py3
    
fi
