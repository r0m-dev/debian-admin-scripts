#!/bin/sh
apt-get update && apt install nfs-kernel-server -yy

echo '/data 192.168.0.25(rw,sync,no_subtree_check)' > /etc/exports

service nfs-kernel-server restart
