# Jarkom-Modul-3-A16-2021
Lapres Praktikum Jarkom Modul 3  
kelompok A16 : Deka Julian Arrizki  

## **Konten**
* [**Cara Pengerjaan**](#cara-pengerjaan)
* [**Catatan**](#catatan)
* [**Kendala**](#kendala)


## Cara Pengerjaan
### Nomor 1
Luffy bersama Zoro berencana membuat peta tersebut dengan kriteria EniesLobby sebagai DNS Server, Jipangu sebagai DHCP Server, Water7 sebagai Proxy Server  
* Setup DNS
```
apt-get update
apt-get install bind9 -y
service bind9 start
```
* Setup DHCP Server
```
apt-get update
apt-get install isc-dhcp-server -y

echo '
INTERFACES="eth0"
' > /etc/default/isc-dhcp-server

service isc-dhcp-server start
```
* Setup Proxy Server
```
apt-get update
apt-get install squid -y
service squid start
```

### Nomor 2
dan Foosha sebagai DHCP Relay
* Setup DHCP Realy
```
apt-get update
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay start
```
* Pasang DHCP Relay ```/etc/default/isc-dhcp-relay```
```
SERVERS="10.7.2.4"
INTERFACES="eth1 eth2 eth3"
OPTIONS=
```
* Pasang IPV4 forward agar bisa menerima network lain ```/etc/sysctl.conf```
```
net.ipv4.ip_forward=1
```

### Nomor 3
Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.20 - [prefix IP].1.99 dan [prefix IP].1.150 - [prefix IP].1.169

* Konfigurasi IP Range DHCP untuk switch 1
```
subnet 10.7.1.0 netmask 255.255.255.0 {
    range 10.7.1.20 10.7.1.99;
    range 10.7.1.150 10.7.1.169;
    option routers 10.7.1.1;
    option broadcast-address 10.7.1.255;
}
```
### Nomor 4
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.30 - [prefix IP].3.50
* Konfigurasi IP Range DHCP untuk switch 3
```
subnet 10.7.3.0 netmask 255.255.255.0 {
    range 10.7.3.30 10.7.3.50;
    option routers 10.7.3.1;
    option broadcast-address 10.7.3.255;
}
```
### Nomor 5
Client mendapatkan DNS dari EniesLobby dan client dapat terhubung dengan internet melalui DNS tersebut.
* Menambahkan konfigurasi forwarders pada ```/etc/bind/named.conf.options```
```
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
```
* Tambahkan konfigurasi pada ```/etc/dhcp/dhcpd.conf``` pada network 10.7.1.0 dan 10.7.3.0
```
option domain-name-servers 10.7.2.2;
```
### Nomor 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 6 menit sedangkan pada client yang melalui Switch3 selama 12 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 120 menit.
* Buka ```/etc/dhcp/dhcpd.conf``` dan tambahkan konfigurasi berikut pada network 10.7.1.0
```
    default-lease-time 360;
    max-lease-time 7200;
```
* Buka ```/etc/dhcp/dhcpd.conf``` dan tambahkan konfigurasi berikut pada network 10.7.3.0
```
    default-lease-time 720;
    max-lease-time 7200;
```
### Nomor 7
Luffy dan Zoro berencana menjadikan Skypie sebagai server untuk jual beli kapal yang dimilikinya dengan alamat IP yang tetap dengan IP [prefix IP].3.69
* Setup ```/etc/network/interfaces``` dan tambahkan konfigurasi berikut di Skypie
```
auto eth0
iface eth0 inet dhcp
hwaddress ether 52:69:bd:d1:b5:14
```
* Kemudian tambahakan konfigurasi pada ```/etc/dhcp/dhcpd.conf``` di Jipangu
```
host Skypie {
    hardware ethernet 52:69:bd:d1:b5:14;
    fixed-address 10.7.3.69;
}
```
### Nomor 8
Loguetown digunakan sebagai client Proxy agar transaksi jual beli dapat terjamin keamanannya, juga untuk mencegah kebocoran data transaksi. Pada Loguetown, proxy harus bisa diakses dengan nama jualbelikapal.yyy.com dengan port yang digunakan adalah 5000
* Konfigurasi pada ```/etc/squid/squid.conf``` di Water7
```
http_port 5000
visible_hostname jualbelikapal.A16.com
```
* Pasang proxy pada loguetown
```
export http_proxy="http://jualbelikapal.A16.com:5000"
```
### Nomor 9
Agar transaksi jual beli lebih aman dan pengguna website ada dua orang, proxy dipasang autentikasi user proxy dengan enkripsi MD5 dengan dua username, yaitu luffybelikapalyyy dengan password luffy_yyy dan zorobelikapalyyy dengan password zoro_yyy
* Buat username dan password
```
htpasswd -c -b /etc/squid/passwd luffybelikapalA16 luffy_A16
htpasswd -b /etc/squid/passwd zorobelikapalA16 zoro_A16
```
* Tambahkan konfigurasi pada ```/etc/squid/squid.conf``` di Water7
```
http_port 5000
visible_hostname jualbelikapal.A16.com

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm AmpunBangJago
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS
```
### Nomor 10
Transaksi jual beli tidak dilakukan setiap hari, oleh karena itu akses internet dibatasi hanya dapat diakses setiap hari Senin-Kamis pukul 07.00-11.00 dan setiap hari Selasa-Jum’at pukul 17.00-03.00 keesokan harinya (sampai Sabtu pukul 03.00)
* Buat konfigurasi untuk akses waktu pada ```/etc/squid/acl.conf``` di Jipangu
```
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time A 00:00-03:00
```
* Tambahkan konfigurasi pada ```/etc/squid/squid.conf``` di Water7
```
include /etc/squid/acl.conf

http_port 5000
visible_hostname jualbelikapal.A16.com

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm Proxy
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow AVAILABLE_WORKING USERS
```
### Nomor 11
Agar transaksi bisa lebih fokus berjalan, maka dilakukan redirect website agar mudah mengingat website transaksi jual beli kapal. Setiap mengakses google.com, akan diredirect menuju super.franky.yyy.com dengan website yang sama pada soal shift modul 2. Web server super.franky.yyy.com berada pada node Skypie
* Tambahkan konfigurasi pada ```/etc/squid/squid.conf``` di Water7
```
acl BLKSite dstdomain google.com
http_access deny BLKSite
deny_info http://super.franky.A16.com BLKSite
```
### Nomor 12
Saatnya berlayar! Luffy dan Zoro akhirnya memutuskan untuk berlayar untuk mencari harta karun di super.franky.yyy.com. Tugas pencarian dibagi menjadi dua misi, Luffy bertugas untuk mendapatkan gambar (.png, .jpg), sedangkan Zoro mendapatkan sisanya. Karena Luffy orangnya sangat teliti untuk mencari harta karun, ketika ia berhasil mendapatkan gambar, ia mendapatkan gambar dan melihatnya dengan kecepatan 10 kbps
* Buat konfigurasi pada ```/etc/squid/acl-bandwidth.conf```
```
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd

acl GETImage url_regex -i \.jpg$ \.png$

acl luffy proxy_auth luffybelikapalA16
acl zoro proxy_auth zorobelikapalA16

delay_pools 1
delay_class 1 1
delay_parameters 1 1250/1250
delay_access 1 allow GETImage luffy
```
### Nomor 13
Sedangkan, Zoro yang sangat bersemangat untuk mencari harta karun, sehingga kecepatan kapal Zoro tidak dibatasi ketika sudah mendapatkan harta yang diinginkannya
* Tambahkan konfigurasi pada ```/etc/squid/acl-bandwidth.conf``` untuk memastikan user zoro tidak terbatasi limit bandwith
```
delay_access 1 deny all
```
## Catatan
1. Jangan lupa restart gan
2. Kalau menggunakan VMWare harus di power off, jika di suspend akan bermasalah pada NAT nya
3. Kalau menggunakan VMWare jika date disetting ke hari sebelumnya dari jadwal default maka akan ke restart otomatis dalam rentang waktu 30s

## Kendala
1. Kendala lebih ke VMWarenya seperti catatan diatas
