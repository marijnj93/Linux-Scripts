#!/bin/bash

apt-get install -y python-pip
pip install docker-py

mkdir -p /srv/salt

echo 'wordpress:
  pkg.installed' > /srv/salt/wordpress.sls

sudo salt '*' state.apply wordpress

salt-call dockerng.sls_build testimage base=my_base_image mods=wordpress