#!/bin/sh
apt-get update && apt install nfs-common -yy
mkdir /mnt/remotenfs
mount /mnt/remotenfs
# FSTAB
echo '192.168.17.254:/srv/data /mnt/remotenfs nfs rw 0 0' >> /etc/fstab
