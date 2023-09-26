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

if [ -d /usr/ports ]; then
	cd /usr/ports
	git reset --hard > /dev/null 2>&1 || true
fi

cbsd portsup

[ -d /usr/ports/sysutils/cbsd-mq-api ] && rm -rf /usr/ports/sysutils/cbsd-mq-api
[ -d /usr/ports/sysutils/garm ] && rm -rf /usr/ports/sysutils/garm
cp -a /root/myb-build/ports/cbsd-mq-api /usr/ports/sysutils/
cp -a /root/myb-build/ports/garm /usr/ports/sysutils/

# devel CBSD
if [ -d /root/myb-build/ports/cbsd ]; then
	[ -d /usr/ports/sysutils/cbsd ] && rm -rf /usr/ports/sysutils/cbsd
	cp -a /root/myb-build/ports/cbsd /usr/ports/sysutils/
fi

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
set -o errexit

#/root/myb-build/ci/00_cleanup.sh
/root/myb-build/ci/00_half-cleanup.sh
#/root/myb-build/ci/00_srcup.sh
#/root/myb-build/ci/10_patch-src.sh
#/root/myb-build/ci/20_world.sh
#/root/myb-build/ci/25_base-pkg.sh
/root/myb-build/ci/30_cpr.sh
/root/myb-build/ci/35_cpr-micro.sh
/root/myb-build/ci/35_update_repo.sh

#fi

# half build
#/root/myb-build/ci/40_jail.sh
#/root/myb-build/ci/44_export-micro.sh
#/root/myb-build/ci/50_purgejail.sh
#/root/myb-build/ci/55_purge_distribution.sh
#/root/myb-build/ci/60_distribution-base.sh
#/root/myb-build/ci/60_distribution-pkg.sh
#/root/myb-build/ci/70_manifests.sh
/root/myb-build/ci/90_conv.sh
#/root/myb-build/ci/95_updaterepo.sh

set +o errexit

exit 0
