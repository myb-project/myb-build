#!/bin/sh

#cp -a /root/myb-build/patch/bootconfig /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/bootconfig

SRC_ROOT="/usr/jails/src/src_13.0/src"

# without installworld ;-)
#cp -a ${SRC_ROOT}/usr.sbin/bsdinstall/scripts/bootconfig /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/bootconfig
cp -a /root/myb-build/patch/bootconfig /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/bootconfig

# RESTORE - on 05_ steps via SRC
#cp -a ${SRC_ROOT}/usr.sbin/bsdinstall/scripts/auto /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/auto

cp -a /root/myb-build/patch/13x/auto /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/auto

# also not for release (IP address for 172.16. here):
cp -a /root/myb-build/patch/13x/netconfig_ipv4 /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/netconfig_ipv4

ver="13.0"
fs="ufs"
jname="jail1"
rm -f /tmp/${jname}-13.0_amd64.img
cbsd jail2iso media=livecd ver=${ver} dstdir=/tmp efi=1 vm_guestfs=${fs} freesize=1024m jname=${jname} applytpl=0
