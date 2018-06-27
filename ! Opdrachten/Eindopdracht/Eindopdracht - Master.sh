#!/bin/bash

############ Install Salt Master

# Change to tmp
cd /tmp

# Download salt
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# install salt (MASTER)
sudo sh install_salt.sh -M

############ Install central syslog-NG server

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

mkdir /var/log/syslog-ng

touch /var/log/syslog-ng/logs.txt

systemctl start syslog-ng

systemctl enable syslog-ng

############ Install NAGIOS

apt-get update

apt-get install -y wget build-essential apache2 php apache2-mod-php7.0 php-gd libgd-dev unzip

wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.0.tar.gz

wget http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz

useradd nagios

groupadd nagcmd

usermod -a -G nagcmd nagios

usermod -a -G nagios,nagcmd www-data

tar zxvf nagios-4.2.0.tar.gz

tar zxvf nagios-plugins-2.1.2.tar.gz

cd nagios-4.2.0

./configure --with-command-group=nagcmd --with-mail=/usr/bin/sendmail -with-httpd-conf=/etc/apache2/

make all

make install

make install-init

make install-config

make install-commandmode

make install-webconf

cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/

chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

cp /etc/apache2/nagios.conf /etc/apache2/sites-available/
cp /etc/apache2/nagios.conf /etc/apache2/sites-enabled/

a2enmod cgi
a2enmod rewrite

echo 'DESC="Nagios"
NAME=nagios
DAEMON=/usr/local/nagios/bin/$NAME
DAEMON_ARGS="-d /usr/local/nagios/etc/nagios.cfg"
PIDFILE=/usr/local/nagios/var/$NAME.lock
' >> /etc/init.d/nagios

systemctl restart apache2

systemctl enable nagios

systemctl start nagios

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

cd /tmp/nagios-plugins-2.1.2

./configure --with-nagios-user=nagios --with-nagios-group=nagios

make

make install

update-rc.d nagios defaults

mkdir -p /usr/local/nagios/etc/servers/

service nagios restart

########### Nagios plugins

apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.1.2.tar.gz
tar zxf nagios-plugins.tar.gz

cd /tmp/nagios-plugins-release-2.1.2/
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install

systemctl restart apache2
service nagios restart