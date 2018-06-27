#!/bin/bash

############ Install Salt Master

apt-get install -y curl

# Change to tmp
cd /tmp

# Download salt
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# install salt (MASTER)
sudo sh install_salt.sh -M
