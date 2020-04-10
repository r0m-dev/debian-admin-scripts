#!/bin/sh
echo 'SSID : '
read WIFISSID
echo 'Clé de cryptage : '
read WIFIKEY
apt-get update && apt-get install iptables-persistent isc-dhcp-server hostapd -yy

sed -i '/INTERFACESv4=/c\INTERFACESv4=\"wlan0\"' /etc/default/isc-dhcp-server
ifconfig wlan0 192.168.100.254/24

DHCPCONF=/etc/dhcp/dhcpd.conf
cat > $DHCPCONF <<EOF
default-lease-time 600;
max-lease-time 7200;
allow booting;
authoritative;

subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.10 192.168.100.200;
  option broadcast-address 192.168.100.255;
  option routers 192.168.100.254;
  option domain-name-servers 192.168.100.254;
}
EOF
# Redémarrage du service DHCP
service isc-dhcp-server restart


HOSTAPDCONF=/etc/hostapd/hostapd.conf

cat > $HOSTAPDCONF <<EOF
interface=wlan0
driver=nl80211
ssid=$WIFISSID
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=$WIFIKEY
rsn_pairwise=CCMP
EOF

# Activation de la configuration
sed -i '/DAEMON_CONF=/c\DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"' /etc/default/hostapd
# Activation du routage
sed -i '/net.ipv4.ip_forward=/c\net.ipv4.ip_forward=1\' /etc/sysctl.conf
sysctl -p

# Flush all rules
#iptables -F
#iptables -X
#iptables -t nat -F
#iptables -t nat -X
#iptables -t mangle -F
#iptables -t mangle -X
#iptables -P INPUT ACCEPT
#iptables -P FORWARD ACCEPT
#iptables -P OUTPUT ACCEPT

# Création de la régle de NAT
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# Sauvegarde des règles
iptables-save > /etc/iptables/rules.v4
# Redémarrage des services
systemctl daemon-reload
systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd

# Lancement au démarrage
update-rc.d hostapd enable
update-rc.d isc-dhcp-server enable

