#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

echo '
127.0.1.1       Water7
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
10.7.3.69       super.franky.A16.com
10.7.2.3        jualbelikapal.A16.com
' > /etc/hosts

apt-get update

apt-get install squid -y

apt-get install apache2-utils -y

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

htpasswd -c -b /etc/squid/passwd luffybelikapalA16 luffy_A16
htpasswd -b /etc/squid/passwd zorobelikapalA16 zoro_A16

echo '
include /etc/squid/acl.conf
include /etc/squid/acl-bandwidth.conf

http_port 5000
visible_hostname jualbelikapal.A16.com

acl BLKSite dstdomain google.com
http_access deny BLKSite
deny_info http://super.franky.A16.com BLKSite

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm Proxy
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow AVAILABLE_WORKING USERS
' > /etc/squid/squid.conf

echo '
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time A 00:00-03:00
' > /etc/squid/acl.conf

echo '
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd

acl GETImage url_regex -i \.jpg$ \.png$

acl luffy proxy_auth luffybelikapalA16
acl zoro proxy_auth zorobelikapalA16

delay_pools 1
delay_class 1 1
delay_parameters 1 1250/1250
delay_access 1 allow GETImage luffy
delay_access 1 deny all
' > /etc/squid/acl-bandwidth.conf

service squid restart