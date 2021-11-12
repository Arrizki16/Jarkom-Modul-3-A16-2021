#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install bind9 -y

echo '
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        // dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
' > /etc/bind/named.conf.options

# NO 7 KEATAS

echo '
zone "jualbelikapal.A16.com" {
    type master;
    file "/etc/bind/jarkom/jualbelikapal.A16.com";
};
zone "super.franky.A16.com" {
    type master;
    file "/etc/bind/jarkom/super.franky.A16.com";
};
' > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom/

cp /etc/bind/db.local /etc/bind/jarkom/jualbelikapal.A16.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     jualbelikapal.A16.com. root.jualbelikapal.A16.com. (
                        2021110701      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@                       IN      NS      jualbelikapal.A16.com.
@                       IN      A       10.7.2.3        ; IP Water7
' > /etc/bind/jarkom/jualbelikapal.A16.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     super.franky.A16.com. root.super.franky.A16.com. (
                        2021110701      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@                       IN      NS      super.franky.A16.com.
@                       IN      A       10.7.3.69        ; IP Skypie
' > /etc/bind/jarkom/super.franky.A16.com


service bind9 restart
