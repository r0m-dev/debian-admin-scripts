#!/bin/sh
echo 'Interface(s) : '
read ETH
# Installation des pré-requis
apt-get update && apt install -yy tftpd-hpa
#/etc/default/tftpd-hpa
mkdir -p '/srv/tftp'
cd /srv/tftp/
wget -c http://ftp.nl.debian.org/debian/dists/stretch/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar -zxf netboot.tar.gz
rm netboot.tar.gz
systemctl restart tftpd-hpa
# Installation du serveur dhcp
apt-get install isc-dhcp-server -yy
# Configuration des interfaces
# /etc/default/isc-dhcp-server
sed -i '/INTERFACESv4=/c\INTERFACESv4=\"$ETH\"' /etc/default/isc-dhcp-server
DHCPCONF=/etc/dhcp/dhcpd.conf
cat > $DHCPCONF <<EOF
default-lease-time 600;
max-lease-time 7200;

allow booting;

subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.10 192.168.1.50;
  option broadcast-address 192.168.1.255;
  option routers 192.168.1.1;
  option domain-name-servers 192.168.1.1;
  filename "pxelinux.0";
}
EOF

# Redémarrage du service DHCP
service isc-dhcp-server restart
