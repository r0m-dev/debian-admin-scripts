#!/bin/bash
#https://github.com/yurygoncharuk/working_with_args/blob/master/parse-options.sh
# default webpath
web_path="/var/www"
VHOST_TYPE="default"

# Add -a option to add vhost
# Add -d option to del vhost
# Add -r option to remove vhost

# read the options
TEMP=`getopt -o -hu:t:p: --long help,url:,type:,port: -n "vhost.sh" -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -h|--help)
            echo "Usage: sh vhost.sh [OPT1] [ARG1]...[OPTN] [ARGN]"
            echo
            echo "Mandatory arguments to long options are mandatory for short options too."
            echo "   -u, --url          www.vhost.com"
            echo "   -t, --type         "
            echo "   -p, --port         5637"
            echo "   -h, --help         display this help and exit"
            shift ; exit 1 ;;
        -u|--url)
            case "$2" in
                "") URL='some default value' ; shift 2 ;;
                *) URL=$2 ; shift 2 ;;
            esac ;;
        -t|--type)
            case "$2" in
                 "") VHOST_TYPE='default' ; shift 1 ;;
                 *) VHOST_TYPE=$2 ; shift 2 ;;
             esac ;;
        -p|--port)
            case "$2" in
                "") shift 2 ;;
                *) PORT=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

######################### PROXY VHOST ##################################

if [ $VHOST_TYPE = "proxy" ] ; then

VHOST_CONF=/etc/apache2/sites-available/$URL.conf
cat > $VHOST_CONF <<EOF
<VirtualHost *:80>
    ServerName $URL
    DocumentRoot "$web_path/$URL/"
    ErrorLog "/var/log/apache2/$URL-errors.log"
    ProxyPass / http://127.0.0.1:$PORT/
    ProxyPassReverse / http://127.0.0.1:$PORT/
    ProxyRequests Off
</VirtualHost>
EOF

mkdir -p $web_path/$URL/
chown -R www-data:www-data $web_path/$URL/
a2ensite $URL
systemctl reload apache2

echo "Your vhost has been created and is now usable !"
echo "$URL"

fi

########################### VHOST SETUP ################################

if [ $VHOST_TYPE = "default" ] ; then

VHOST_CONF=/etc/apache2/sites-available/$URL.conf
cat > $VHOST_CONF <<EOF
<VirtualHost *:80>
    ServerName $URL
    DocumentRoot "$web_path/$URL/"
    ErrorLog "/var/log/apache2/$URL-errors.log"
    <directory "/$web_path/$URL/">
        Options Indexes FollowSymLinks
        AllowOverride all
        Order Deny,Allow
                Deny from all
        Allow from all
    </directory>
</VirtualHost>
EOF

mkdir -p $web_path/$URL/
chown -R www-data:www-data $web_path/$URL/
a2ensite $URL
systemctl reload apache2

echo "Your vhost has been created and is now usable !"
echo "$URL"
fi

######################################################################
