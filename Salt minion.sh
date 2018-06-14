#!/bin/bash

# Sudo rights
sudo -i

# Change to tmp
cd /tmp

# Download salt 
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# install salt (MINION)
sh install_salt.sh

# point to master
echo 'master: UBU1604-SALTMASTER' >> /etc/salt/minion

# Restart salt-minion
service salt-minion restart
