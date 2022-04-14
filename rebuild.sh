#!/bin/sh

set -o errexit

cd /

# refresh modules
[ -d /root/myb-build/myb-extras/myb.d ] && rm -rf /root/myb-build/myb-extras/myb.d
cp -a /usr/local/cbsd/modules/myb.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/myb.d/.git || true
cp -a /usr/local/cbsd/modules/k8s.d /root/myb-build/myb-extras/
rm -rf /root/myb-build/myb-extras/k8s.d/.git || true

[ -d /root/myb-build/myb-extras/k8s.d/share/k8s-system-default ] && rm -rf /root/myb-build/myb-extras/k8s.d/share/k8s-system-default
cp -a /root/myb-build/myb-extras/k8s-system-default /root/myb-build/myb-extras/k8s.d/share/

#/root/myb-build/ci/00_srcup.sh
#/root/myb-build/ci/10_patch-src.sh
#/root/myb-build/ci/20_world.sh
#/root/myb-build/ci/30_cpr.sh
/root/myb-build/ci/40_jail.sh
/root/myb-build/ci/50_purgejail.sh
/root/myb-build/ci/60_distribution.sh
/root/myb-build/ci/70_manifests.sh
/root/myb-build/ci/90_conv.sh

echo
echo "scp /tmp/mybee1-13.1_amd64.img oleg@172.16.0.3:mybee1-13.1_amd64.img"
echo
echo "cd /usr/jails/jails-data/mybee1-data/usr/freebsd-dist"
echo "sftp -oPort=222 oleg@www.bsdstore.ru   -> /usr/local/www/myb.convectix.com/"
echo "or"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/MANIFEST oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/base.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/cbsd.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo "scp -oPort=222 /usr/jails/jails-data/mybee1-data/usr/freebsd-dist/kernel.txz oleg@www.bsdstore.ru:/usr/local/www/myb.convectix.com/"
echo
