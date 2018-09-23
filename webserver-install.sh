#!/bin/bash
apt update && apt full-upgrade -yy 
# Pré-requis
apt install htop net-tools software-properties-common build-essential fail2ban -yy
# Installation de Apache 2
apt install apache2 -yy
# Generate pass
rand=$(head -c 100 /dev/urandom | tr -dc A-Za-z0-9 | head -c13)
# Préparation de l'installation de Mariadb
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password $rand"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $rand"
# Install MariaDB
apt install -yy mariadb-server
mysql -uroot -p$rand -e "update mysql.user SET PASSWORD = PASSWORD('$rand') where User='root';"
mysql -uroot -p$rand -e 'update mysql.user set plugin="mysql_native_password";'
mysql -uroot -p$rand -e "FLUSH PRIVILEGES;"
# Installation de PHP 7.0
apt install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-mbstring  php7.0-xml php7.0-zip -yy
clear
echo "-------------------------------------------------------------"
echo "Votre mot de passe MySQL est le suivant : "$rand
echo "-------------------------------------------------------------"
