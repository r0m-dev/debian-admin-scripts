#Pre-requis
apt-get update && apt-get install isc-dhcp-server -yy

# nano /etc/dhcp/dhcpd.conf 

ddns-update-style none;
option domain-name "local.lan";
option domain-name-servers 9.9.9.9, 1.1.1.1;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;
subnet 192.168.17.0 netmask 255.255.255.0 {
    range 192.168.17.100 192.168.17.150;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.17.255;
    option routers 192.168.17.254;
}


# Edition du fichier de configuration
nano /etc/default/isc-dhcp-server
# Contenu à modifier
INTERFACES="eth0"
```
