#!/bin/bash

sudo -i
sudo apt-get update
sudo apt-get install wget build-essential apache2 php apache2-mod-php7.0 php-gd libgd-dev unzip
cd /tmp
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
sudo update-rc.d nagios defaults

# Add hosts and services

mkdir -p /usr/local/nagios/etc/servers/

touch /usr/local/nagios/etc/servers/remotehost.cfg

echo 'cfg_file=/usr/local/nagios/etc/servers/remotehost.cfg' >> /usr/local/nagios/etc/nagios.cfg 

echo 'define host {
    use                         linux-server
    host_name                   UBU1604-SALTMASTER
    alias                       remotehost
    address                     10.0.0.5
    register                    1
}
define service {
    host_name                   UBU1604-SALTMASTER
    use                         generic-service
    service_description         HTTP
    check_command               check_http!UBU1604-SALTMASTER!-S --onredirect=follow
    register                    1
}
define service {
    host_name                   UBU1604-SALTMASTER
    use                         generic-service
    service_description         SSH
    check_command               check_ssh
    register                    1
}
' >> /usr/local/nagios/etc/servers/remotehost.cfg

service nagios restart 
