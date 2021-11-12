#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install php -y

apt-get install apache2 -y

apt-get install unzip -y

apt-get install lynx -y

apt-get install libapache2-mod-php7.0 -y

service apache2 start

apt-get install wget -y

wget "https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip" -P /var/www/source
unzip /var/www/source/super.franky.zip -d /var/www/source

mkdir /var/www/super.franky.A16.com

cp -r /var/www/source/super.franky/. /var/www/super.franky.A16.com

rm -r /var/www/source

echo '
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/super.franky.A16.com
        ServerName super.franky.A16.com
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
' > /etc/apache2/sites-available/000-default.conf

service apache2 restart

