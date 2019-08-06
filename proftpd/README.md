## Installation et configuration de proftpd

```shell
apt update && apt install -y proftpd
```
Edition du fichier de conf /etc/proftpd/proftpd.conf :
```bash
# Nom du serveur (identique à celui définit dans /etc/hosts)
ServerName "Server Name"

# Message de connexion
DisplayLogin "Bienvenue sur le FTP de Server Name"

# Désactiver IPv6
UseIPv6 off

# Chaque utilisateur accède seulement à son home (pour les membres du groupe ftp2100)
DefaultRoot ~ ftpgroup

# Users cannot have a valid shell
RequireValidShell off

# Port (défaut = 21)
Port 21

# Specifiyng passive port
PassivePorts 40000 50000

# Refuser la connexion super-utilisateur "root"
RootLogin off

# Nombre de clients FTP max.
MaxClients 2

# En précisant "!" on refuse tout sauf le groupe "ftpgroup"
<Limit LOGIN>
DenyGroup !ftpgroup
</Limit>
```
Création du groupe ftpgroup
```shell
addgroup ftpgroup
```
Création d'un faux shell
```shell
echo "/bin/false" >> /etc/shells
```
Création d'un utilisateur et ajout dans le group ftpgroup
```shell
adduser user1 --shell /bin/false --home /home/user1 --ingroup ftpgroup
```
## Configuration TLS
Génération du certificat
```shell
openssl genrsa -out /etc/ssl/private/proftpd.key 4096
```
Autosignature du certificat.
```shell
openssl req -new -x509 -days 3650 -key /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt
```
Ajout de la conf TLS en créant le fichier /etc/proftpd/conf.d/tls.conf
```bash
<IfModule mod_tls.c>
# Enable TLS
TLSEngine on

# Log file
TLSLog /var/log/proftpd/tls.log

# Protocol
TLSProtocol SSLv23

# Authenticate clients that want to use FTP over TLS?
TLSVerifyClient off

# Are clients required to use FTP over TLS when talking to this server?
TLSRequired on

# Certificates
TLSRSACertificateFile /etc/ssl/certs/proftpd.crt
TLSRSACertificateKeyFile /etc/ssl/private/proftpd.key
</IfModule>
```
## A lire

:boom: Attention
avant de redémarrer le service, il faut s’assurer que le nom passé à ServerName dans le fichier de configuration correspond au nom de la machine dans le fichier /etc/hosts. Dans le cas contraire il convient de le modifier.

Redémarrage du service :
```shell
systemctl restart proftpd
```
