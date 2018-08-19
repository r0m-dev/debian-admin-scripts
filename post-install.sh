#!/bin/sh
echo Email admin ?
read email
apt update && apt full-upgrade -yy
# Configure locale
echo -e 'LANG="fr_FR.UTF-8"\nLANGUAGE="fr_FR:fr"\n' > /etc/default/locale
# Mail notification
echo 'root: $email' > /etc/aliases
# Desactivation IPV6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.autoconf = 0' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.autoconf = 0' >> /etc/sysctl.conf
sysctl -p
# Install pre-requisite
apt install curl htop fail2ban net-tools nmap apt-transport-https dirmngr neofetch mc build-essential certbot unzip -yy
apt install smartmontools -yy
# Purge /etc/motd
echo '' > /etc/motd
sysctl -p
# Autoriser le Root login via SSH
sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
service sshd restart
BASHRCCONF=/root/.bashrc
cat > $BASHRCCONF <<EOF
neofetch
alias ippub="curl http://ifconfig.me/ip"
alias ipeth0="$(ifconfig eth0 | grep -w 'inet' | awk '{print $2}')"
alias ipwlan0="$(ifconfig wlan0 | grep -w 'inet' | awk '{print $2}')"
EOF
source ~/.bashrc
