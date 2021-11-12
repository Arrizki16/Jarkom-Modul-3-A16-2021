#!/bin/bash

apt-get update

apt-get install isc-dhcp-relay -y

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.7.0.0/1

echo '
# What servers should the DHCP relay forward requests to?
SERVERS="10.7.2.4"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=
' > /etc/default/isc-dhcp-relay

echo '
net.ipv4.ip_forward=1
' > /etc/sysctl.conf

service isc-dhcp-relay restart