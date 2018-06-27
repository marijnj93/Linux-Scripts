#!/bin/bash

# Before running this script do the following:
# Change "UBU1604-SALTMASTER" to the IP address or Hostname of the SALT Master.
# Change "10.0.0.4" to the IP address of the Syslog-NG server.

# Parameters
SALTMASTER="UBU1604-SALTMASTER"
SYSLOGDEST="10.0.0.4"

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

############ Install Syslog-NG client

# Change to tmp
cd /tmp

wget -qO - http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04/Release.key | sudo apt-key add -

echo 'deb http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04 ./' >> /etc/apt/sources.list.d/syslog-ng-obs.list

apt-get update
apt-get install -y syslog-ng-core
mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.bak

touch /etc/syslog-ng/syslog-ng.conf
echo '@version: 3.5
@include "scl.conf"
@include "`scl-root`/system/tty10.conf"
source s_local { system(); internal(); };
' >> /etc/syslog-ng/syslog-ng.conf
echo "destination d_syslog_tcp {
              syslog("$SYSLOGDEST" transport("tcp") port(514)); };
log { source(s_local);destination(d_syslog_tcp); }; 
" >> /etc/syslog-ng/syslog-ng.conf

systemctl start syslog-ng
systemctl enable syslog-ng
systemctl restart syslog-ng
