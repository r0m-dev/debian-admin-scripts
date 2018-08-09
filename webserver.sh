#!/bin/bash
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
apt install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-mbstring  php7.0-xml php7.0-zip


