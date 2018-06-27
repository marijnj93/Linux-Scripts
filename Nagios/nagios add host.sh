#!/bin/bash

######### Add hosts and services

touch /usr/local/nagios/etc/servers/UBU1604-SALTMINION.cfg

echo 'define host {
    use                         linux-server
    host_name                   UBU1604-SALTMINION
    alias                       UBU1604-SALTMINION
    address                     10.0.0.5
    register                    1
}
define service {
    host_name                   UBU1604-SALTMINION
    use                         generic-service
    service_description         HTTP
    check_command               check_http!UBU1604-SALTMINION!-S --onredirect=follow
    register                    1
}
define service {
    host_name                   UBU1604-SALTMINION
    use                         generic-service
    service_description         SSH
    check_command               check_ssh
    register                    1
}
' >> /usr/local/nagios/etc/servers/UBU1604-SALTMINION.cfg

systemctl restart nagios.service