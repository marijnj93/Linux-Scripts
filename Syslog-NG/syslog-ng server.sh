#!/bin/bash

############ Install Syslog-NG server

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
    options {
        time-reap(30);
        mark-freq(10);
        keep-hostname(yes);
        };
    source s_local { system(); internal(); };
    source s_network {
        syslog(transport(tcp) port(514));
        };
    destination d_local {
    file("/var/log/syslog-ng/messages_${HOST}"); };
    destination d_logs {
        file(
            "/var/log/syslog-ng/logs.txt"
            owner("root")
            group("root")
            perm(0777)
            ); };
    log { source(s_local); source(s_network); destination(d_logs); };' >> /etc/syslog-ng/syslog-ng.conf

sudo mkdir /var/log/syslog-ng
sudo touch /var/log/syslog-ng/logs.txt
sudo systemctl start syslog-ng
sudo systemctl enable syslog-ng
systemctl restart syslog-ng
