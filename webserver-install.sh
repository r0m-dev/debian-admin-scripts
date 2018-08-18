#!/bin/bash
apt-get update
# Installation de Apache 2
apt-get install apache2 -yy
# Install MariaDB
apt-get install software-properties-common -yy
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64] http://ftp.igh.cnrs.fr/pub/mariadb/repo/10.3/debian stretch main'

# Generate pass

rand=$(head -c 100 /dev/urandom | tr -dc A-Za-z0-9 | head -c13)

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password password $rand'
debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password_again password $rand'
apt-get install -yy mariadb-server
mysql -uroot -p$rand -e "SET PASSWORD = PASSWORD('$rand');"

# Installation de PHP 7.0
apt install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-mbstring  php7.0-xml php7.0-zip -yy

clear
echo'-----------------------------------------------------'
echo'Votre mot de passe MySQL est le suivant : '$rand
echo'-----------------------------------------------------'


