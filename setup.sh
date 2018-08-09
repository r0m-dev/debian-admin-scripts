#!/bin/bash
echo Votre email ?
read email
apt update && apt full-upgrade -yy
# Configure locale
locale-gen --purge en_US.UTF-8
echo -e 'LANG="fr_FR.UTF-8"\nLANGUAGE="fr_FR:fr"\n' > /etc/default/locale
# Mail notification
echo 'root: $email' > /etc/aliases
# Install pre-requisite
apt install htop fail2ban net-tools nmap apt-transport-https dirmngr neofetch mc build-essential certbot unzip -yy
apt install smartmontools -yy
# Copy neofetch conf
mkdir -p $HOME/.config/neofetch/ && mv config/config-neofetch $HOME/.config/neofetch/config
# Purge /etc/motd
echo '' > /etc/motd
service ssh reload
# Install Docker
echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update && apt-get install docker-engine -yy
# Installation de Apache 2
apt-get install apache2 -yy
echo '<?php phpinfo(); ?>' > /var/www/index.php
# Install MariaDB
apt-get install software-properties-common -y
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64] http://ftp.igh.cnrs.fr/pub/mariadb/repo/10.3/debian stretch main'
apt-get update && apt-get install -yy mariadb-server
# MySQL secure install
mysql_secure_installation
# Installation de PHP 7.0
apt-get install -yy php-common php-pear php-zip php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-fpm php7.0-gd php7.0-imap php7.0-intl php7.0-json php7.0-mbstring php7.0-mysql php7.0-opcache php7.0-pspell php7.0-readline php7.0-recode php7.0-snmp php7.0-tidy php7.0-xml php7.0-zip
