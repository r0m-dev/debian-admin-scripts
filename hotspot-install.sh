#!/bin/sh
echo 'Interface ? : '
read WIFIETH
echo 'SSID : '
read WIFISSID
echo 'Clé de cryptage : '
read WIFIKEY
apt-get update && apt-get install hostapd -yy
HOSTAPDCONF=/etc/hostapd/hostapd.conf

cat > $HOSTAPDCONF <<EOF
# This is the name of the WiFi interface we configured above
interface=$WIFIETH
# Use the nl80211 driver with the brcmfmac driver
driver=nl80211
# This is the name of the network
ssid=$WIFISSID
# Use the 2.4GHz band
hw_mode=g
# Use channel 6
channel=6
# Enable 802.11n
ieee80211n=1
# Enable WMM
wmm_enabled=1
# Enable 40MHz channels with 20ns guard interval
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
# Accept all MAC addresses
macaddr_acl=0
# Use WPA authentication
auth_algs=1
# Require clients to know the network name
ignore_broadcast_ssid=0
# Use WPA2
wpa=2
# Use a pre-shared key
wpa_key_mgmt=WPA-PSK
# The network passphrase
wpa_passphrase=$WIFIKEY
# Use AES, instead of TKIP
rsn_pairwise=CCMP
EOF

# Activation de la configuration
sed -i '/DAEMON_CONF=/c\DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"' /etc/default/hostapd
# Activation du routage
sed -i '/net.ipv4.ip_forward=/c\net.ipv4.ip_forward=\"1\"' /etc/sysctl.conf
# Création de la régle de NAT
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
# Sauvegarde de la régle de NAT
sh -c "iptables-save > /etc/iptables.ipv4.nat"
# Ajout de la régle de NAT au boot du RPI
echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
# Redémarrage des services
systemctl daemon-reload
/etc/init.d/hostapd restart
