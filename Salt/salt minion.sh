#!/bin/bash

# Before running this script do the following:
# Change "UBU1604-SALTMASTER" to the IP address or Hostname of the SALT Master.

# Parameters
SALTMASTER="UBU1604-SALTMASTER"

############ Install Salt Minion

apt-get install -y curl

# Change to tmp
cd /tmp

# Download salt 
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# install salt (MINION)
sh install_salt.sh -A $SALTMASTER

# Restart salt-minion
service salt-minion restart
