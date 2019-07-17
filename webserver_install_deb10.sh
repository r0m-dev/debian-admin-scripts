#!/bin/bash
apt update && apt upgrade -yy
# Generate MariaDB password
rand=$(head -c 100 /dev/urandom | tr -dc A-Za-z0-9 | head -c13)
# Conf Mariadb
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password $rand"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $rand"
# Packages installation
apt -y install php php-common
apt -y install php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath
apt -y install git htop net-tools software-properties-common build-essential fail2ban curl unzip apache2 libapache2-mod-php python-certbot-apache open-vm-to$
# Certbot installation
cd /opt
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
# Apache module activation
a2enmod php7.3
a2enmod rewrite
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
# MySQL Conf
sed -i '/bind-address/s/^/#/g' /etc/mysql/mariadb.conf.d/50-server.cnf
mysql -uroot -p$rand -e "update mysql.user SET PASSWORD = PASSWORD('$rand') where User='root';"
mysql -uroot -p$rand -e 'update mysql.user set plugin="mysql_native_password";'
mysql -uroot -p$rand -e "FLUSH PRIVILEGES;"
# Adminer install
mkdir /usr/share/adminer
wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf
a2enconf adminer.conf
# Restart all services
/etc/init.d/apache2 restart
/etc/init.d/mysql restart
# Get infos
echo "----------------------------------------------------"
echo "Your MariaDB password : "$rand
echo "----------------------------------------------------"
