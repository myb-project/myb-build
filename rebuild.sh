#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
### SET version in /root/myb-build/ports/myb/Makefile
### + /root/myb-build/jail-skel/usr/local/etc/mybee/version

# Brand, used in sysinstall/bsdconfig...
export OSNAME="MyBee"

cd /

#if [ 1 -gt 2 ]; then

set -o errexit

if [ ! -r /usr/ports/Makefile ]; then
	echo "No such /usr/ports"
	exit 1
fi

GIT_CMD=$( which git )
RSYNC_CMD=$( which rsync )

# first init
#if [ ! -d /root/clonos-ports ]; then
#	${GIT_CMD} clone https://github.com/clonos/clonos-ports-wip.git /root/clonos-ports
#else
#	cd /root/clonos-ports
#	${GIT_CMD} pull
#fi

#${RSYNC_CMD} -avz /root/clonos-ports/ /usr/ports/


cbsd jremove jname='cpr*'
rm -rf /var/cache/packages/*
[ -d /usr/ports/sysutils/cbsd-mq-api ] && rm -rf /usr/ports/sysutils/cbsd-mq-api
[ -d /usr/ports/sysutils/garm ] && rm -rf /usr/ports/sysutils/garm
cp -a /root/myb-build/ports/cbsd-mq-api /usr/ports/sysutils/
cp -a /root/myb-build/ports/garm /usr/ports/sysutils/

# devel CBSD
[ -d /usr/ports/sysutils/cbsd ] && rm -rf /usr/ports/sysutils/cbsd
cp -a /root/myb-build/ports/cbsd /usr/ports/sysutils/

# refresh modules
[ -d /root/myb-build/myb-extras/myb.d ] && rm -rf /root/myb-build/myb-extras/myb.d
[ -d /root/myb-build/myb-extras/garm.d ] && rm -rf /root/myb-build/myb-extras/garm.d
[ -d /root/myb-build/myb-extras/api.d ] && rm -rf /root/myb-build/myb-extras/api.d
[ -d /root/myb-build/myb-extras/k8s.d ] && rm -rf /root/myb-build/myb-extras/k8s.d
# garm.d
cp -a /usr/local/cbsd/modules/garm.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/garm.d/.git || true
# myb.d
cp -a /usr/local/cbsd/modules/myb.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/myb.d/.git || true
# k8s.d
cp -a /usr/local/cbsd/modules/k8s.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/k8s.d/.git || true
[ -d /root/myb-build/myb-extras/k8s.d/share/k8s-system-default ] && rm -rf /root/myb-build/myb-extras/k8s.d/share/k8s-system-default
cp -a /root/myb-build/myb-extras/k8s-system-default /root/myb-build/myb-extras/k8s.d/share/
# api.d
cp -a /usr/local/cbsd/modules/api.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/api.d/.git || true


# !!!
# not for half:
/root/myb-build/ci/00_cleanup.sh
/root/myb-build/ci/00_srcup.sh
/root/myb-build/ci/10_patch-src.sh
/root/myb-build/ci/20_world.sh
/root/myb-build/ci/30_cpr.sh
# need to chick-egg - we need myb.pkg:
/root/myb-build/ci/95_updaterepo.sh
/root/myb-build/ci/35_cpr-micro.sh

#fi

# half build
/root/myb-build/ci/40_jail.sh
/root/myb-build/ci/44_export-micro.sh
/root/myb-build/ci/50_purgejail.sh
/root/myb-build/ci/55_purge_distribution.sh
/root/myb-build/ci/60_distribution.sh
/root/myb-build/ci/70_manifests.sh
/root/myb-build/ci/90_conv.sh
/root/myb-build/ci/95_updaterepo.sh

chmod 0644 /tmp/mybee1-14.0_amd64.img
chmod 0644 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/*

echo
echo "scp /tmp/mybee1-14.0_amd64.img oleg@172.16.0.3:mybee1-14.0_amd64.img"
echo
echo "cd /usr/jails/jails-data/mybee1-data/usr/freebsd-dist"
echo "sftp -oPort=222 oleg@www.bsdstore.ru   -> /usr/local/www/myb.convectix.com/"
echo "or"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/MANIFEST oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/base.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/cbsd.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/kernel.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo
