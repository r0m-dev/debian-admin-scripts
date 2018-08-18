#!/bin/sh
echo 'Interface(s) : '
read ETH
# Installation des pré-requis
apt-get update && apt install -yy nfs-kernel-server tftpd-hpa syslinux-efi pxelinux

echo '/srv/tftp/boot *(ro,async,no_root_squash,no_subtree_check)' >> /etc/exports
service nfs-kernel-server restart

#/etc/default/tftpd-hpa
rm -rf /srv/tftp/
mkdir -p /srv/tftp/boot/
mkdir -p /srv/tftp/bios/pxelinux.cfg/
mkdir -p /srv/tftp/efi32/pxelinux.cfg/
mkdir -p /srv/tftp/efi64/pxelinux.cfg/
cd /srv/tftp/bios && ln -s ../boot boot
cd /srv/tftp/efi32 && ln -s ../boot boot
cd /srv/tftp/efi64 && ln -s ../boot boot
cp /usr/lib/syslinux/modules/bios/* /srv/tftp/bios/
cp /usr/lib/PXELINUX/pxelinux.0 /srv/tftp/bios/
cp /usr/lib/syslinux/modules/efi64/* /srv/tftp/efi64/
cp /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi /srv/tftp/efi64/
cp /usr/lib/syslinux/modules/efi32/* /srv/tftp/efi32/
cp /usr/lib/SYSLINUX.EFI/efi32/syslinux.efi /srv/tftp/efi32/
cp pxe/french.kbd /srv/tftp/bios/pxelinux.cfg/
cp pxe/french.kbd /srv/tftp/efi64/pxelinux.cfg/
cp pxe/french.kbd /srv/tftp/efi32/pxelinux.cfg/
mkdir -p /srv/tftp/boot/debian/installer/stretch/
cd /tmp
wget -c http://ftp.nl.debian.org/debian/dists/stretch/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar -zxf netboot.tar.gz
mv debian-installer/amd64/ /srv/tftp/boot/debian/installer/stretch/
BIOSCONF=/srv/tftp/bios/pxelinux.cfg/default
cat > $BIOSCONF <<EOF
DEFAULT vesamenu.c32
PROMPT 0
TIMEOUT 300
ONTIMEOUT 0
NOESCAPE 1
KBDMAP french.kbd

menu title **** Menu BIOS PXE ****

label 0
menu label ^Demarrage sur disque dur local
menu default
localboot 0

label 1
menu label ^Redemarrage
kernel reboot.c32

label 2
menu label ^Arret
kernel poweroff.c32

LABEL 3
MENU LABEL ^HDT - Outil de detection materiel
KERNEL hdt.c32

LABEL 4
MENU LABEL Netboot Debian 9
KERNEL boot/debian/installer/stretch/amd64/linux
APPEND vga=788 initrd=boot/debian/installer/stretch/amd64/initrd.gz --- quiet

EOF

EFI64CONF=/srv/tftp/efi64/pxelinux.cfg/default
cat > $EFI64CONF <<EOF
DEFAULT vesamenu.c32
PROMPT 0
TIMEOUT 300
ONTIMEOUT 0
NOESCAPE 1
KBDMAP french.kbd

menu title **** Menu EFI64 PXE ****

label 0
menu label ^Demarrage sur disque dur local
menu default
localboot 0

label 1
menu label ^Redemarrage
kernel reboot.c32

label 2
menu label ^Arret
kernel poweroff.c32

LABEL 3
MENU LABEL ^HDT - Outil de detection materiel
KERNEL hdt.c32

LABEL 4
MENU LABEL Netboot Debian 9
KERNEL boot/debian/installer/stretch/amd64/linux
APPEND vga=788 initrd=boot/debian/installer/stretch/amd64/initrd.gz --- quiet
EOF

EFI32CONF=/srv/tftp/efi32/pxelinux.cfg/default
cat > $EFI32CONF <<EOF
default vesamenu.c32
prompt 0
timeout 300
ontimeout 0.0
noescape 1
KBDMAP french.kbd

menu title **** Menu EFI32 PXE ****

label 0
menu label ^Demarrage sur disque dur local
menu default
localboot 0

label 1
menu label ^Redemarrage
kernel reboot.c32

label 2
menu label ^Arret
kernel poweroff.c32

LABEL 3
MENU LABEL ^HDT - Outil de detection materiel
KERNEL hdt.c32

LABEL 4
MENU LABEL Netboot Debian 9
KERNEL boot/debian/installer/stretch/amd64/linux
APPEND vga=788 initrd=boot/debian/installer/stretch/amd64/initrd.gz --- quiet

EOF

systemctl restart tftpd-hpa
# Installation du serveur dhcp
apt-get install isc-dhcp-server -yy
# Configuration des interfaces
# /etc/default/isc-dhcp-server
sed -i '/INTERFACESv4=/c\INTERFACESv4=\"$ETH\"' /etc/default/isc-dhcp-server
DHCPCONF=/etc/dhcp/dhcpd.conf
cat > $DHCPCONF <<EOF
default-lease-time 600;
max-lease-time 7200;

allow booting;

authoritative;

option space PXE;
option PXE.mtftp-ip code 1 = ip-address;
option PXE.mtftp-cport code 2 = unsigned integer 16;
option PXE.mtftp-sport code 3 = unsigned integer 16;
option PXE.mtftp-tmout code 4 = unsigned integer 8;
option PXE.mtftp-delay code 5 = unsigned integer 8;
option arch code 93 = unsigned integer 16;


subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.10 192.168.1.50;
  option broadcast-address 192.168.1.255;
  option routers 192.168.1.1;
  option domain-name-servers 192.168.1.1;
  option tftp-server-name "192.168.1.111";
  option root-path "/srv/tftp/";

  #filename "pxelinux.0";
  if option arch = 00:06 {
                filename "efi32/syslinux.efi";
        } else if option arch = 00:07 {
                filename "efi64/syslinux.efi";
        } else if option arch = 00:09 {
                filename "efi64/syslinux.efi";
        } else {
                filename "bios/pxelinux.0";
        }
}

subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.10 192.168.100.200;
  option broadcast-address 192.168.100.255;
  option routers 192.168.100.254;
  option domain-name-servers 192.168.100.254;
}
EOF

# Redémarrage du service DHCP
service isc-dhcp-server restart
