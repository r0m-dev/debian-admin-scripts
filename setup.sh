#!/bin/bash
apt update && apt full-upgrade -yy
# Install pre-requisite
apt install htop fail2ban net-tools nmap apt-transport-https dirmngr neofetch git build-essential unzip -yy
# Copy neofetch conf
# ....
# Install Docker
echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update && apt-get install docker-engine -yy
