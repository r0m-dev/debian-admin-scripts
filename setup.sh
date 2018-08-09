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
