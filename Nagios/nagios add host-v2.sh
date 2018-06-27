#!/bin/bash

# Before running this script do the following:
# Change the Parameter "HOST" to the IP address or Hostname of the host to monitor.
# Change the Parameter "IP" to the IP address of the host to monitor.

# Parameter
HOST="UBU1604-SALTMINION"
IP="192.168.75.130"

######### Add hosts and services

echo "define host {
    use                         linux-server
    host_name                   $HOST
    alias                       $HOST
    address                     $IP
    register                    1
}
define service {
    host_name                   $HOST
    use                         generic-service
    service_description         HTTP
    check_command               check_http
    register                    1
}
define service {
    host_name                   $HOST
    use                         generic-service
    service_description         SSH
    check_command               check_ssh
    register                    1
}
" > /usr/local/nagios/etc/servers/$HOST.cfg

systemctl restart nagios.service
