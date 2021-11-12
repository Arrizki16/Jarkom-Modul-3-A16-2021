#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

echo '
# auto eth0
# iface eth0 inet static
#         address 10.7.1.3
#         netmask 255.255.255.0
#         gateway 10.7.1.1

auto eth0
iface eth0 inet dhcp
' > /etc/network/interfaces