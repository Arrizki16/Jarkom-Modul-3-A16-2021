#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install isc-dhcp-server -y

echo '
INTERFACES="eth0"
' > /etc/default/isc-dhcp-server

echo '
subnet 10.7.2.0 netmask 255.255.255.0 {
}

subnet 10.7.1.0 netmask 255.255.255.0 {
    range 10.7.1.20 10.7.1.99;
    range 10.7.1.150 10.7.1.169;
    option routers 10.7.1.1;
    option broadcast-address 10.7.1.255;
    option domain-name-servers 10.7.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}

subnet 10.7.3.0 netmask 255.255.255.0 {
    range 10.7.3.30 10.7.3.50;
    option routers 10.7.3.1;
    option broadcast-address 10.7.3.255;
    option domain-name-servers 10.7.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}

host Skypie {
    hardware ethernet 52:69:bd:d1:b5:14;
    fixed-address 10.7.3.69;
}
' > /etc/dhcp/dhcpd.conf


service isc-dhcp-server restart