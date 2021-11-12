#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install lynx -y

date -s "8 NOV 2021 18:46:00"

echo '
# auto eth0
# iface eth0 inet static
#         address 10.7.1.3
#         netmask 255.255.255.0
#         gateway 10.7.1.1

auto eth0
iface eth0 inet dhcp
' > /etc/network/interfaces

export http_proxy="http://jualbelikapal.A16.com:5000"

# JANGAN LUPA RESTART LOGUETOWN
