#!/bin/sh
echo "Installation en cours..."
echo "------------------------------------------------------"
apt update && apt full-upgrade -yy -qq > /dev/null
echo "Mise à jour : OK"
# Pré-requis
apt install htop net-tools software-properties-common build-essential fail2ban -yy -qq > /dev/null
# Installation de Apache 2
apt install apache2 -yy -qq > /dev/null
a2enmod rewrite
a2enmod ssl
a2enmod proxy
echo "Installation d'Apache 2 : OK"
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
echo "Installation de MySQL : OK"
# Installation de PHP 7.0
apt install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-mbstring  php7.0-xml php7.0-zip -yy -qq > /dev/null
# Installation de Certbot auto pour apache
apt install python-certbot-apache -yy -qq > /dev/null
echo "Installation de PHP7.0 : OK"
cd /opt
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
# Reload Apache2
systemctl restart apache2
clear
echo "-------------------------------------------------------------"
echo " Installation terminée"
echo "-------------------------------------------------------------"
echo " # MySQL"
echo " Votre mot de passe MySQL est le suivant : "$rand
echo ""
echo " # Certbot-auto"
echo " ./certbot-auto se trouve dans le répertoire /opt "
echo "-------------------------------------------------------------"
