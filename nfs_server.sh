#!/bin/sh
apt-get update && apt install nfs-kernel-server -yy  

mkdir -p /srv/data  

echo '/srv/data 192.168.17.0/24(rw,sync,no_subtree_check)' >> /etc/exports 
exportfs -ra  
service nfs-kernel-server restart  

