#!/bin/bash

# Sudo rights
sudo -i

# Change to tmp
cd /tmp

##################################### Send logs to monitoring server
wget -qO - http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04/Release.key | sudo apt-key add -

echo 'deb http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04 ./' >> /etc/apt/sources.list.d/syslog-ng-obs.list

apt-get update
apt-get install -y syslog-ng-core
mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.bak

# Change the ip address to ip of the central syslog server
touch /etc/syslog-ng/syslog-ng.conf
echo '@version: 3.5
@include "scl.conf"
@include "`scl-root`/system/tty10.conf"
source s_local { system(); internal(); };
destination d_syslog_tcp {
              syslog("10.0.0.4" transport("tcp") port(514)); };
log { source(s_local);destination(d_syslog_tcp); }; 
' >> /etc/syslog-ng/syslog-ng.conf

systemctl start syslog-ng
systemctl enable syslog-ng