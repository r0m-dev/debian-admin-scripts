# Installation du loader ioncube
cd /root
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xvzf ioncube_loaders_lin_x86-64.tar.gz
cd ioncube
cp ioncube_loader_lin_7.0.so /usr/lib/php/20151012/
echo 'zend_extension=/usr/lib/php/20151012/ioncube_loader_lin_7.0.so' >> /etc/php/7.0/apache2/php.ini
echo 'zend_extension=/usr/lib/php/20151012/ioncube_loader_lin_7.0.so' >> /etc/php/7.0/cli/php.ini
/etc/init.d/apache2 restart
