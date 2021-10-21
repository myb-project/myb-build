#!/bin/sh
## check for best compress/size/speed val:


cd /root/myb-build
[ -r cbsd.tar ] && rm -f cbsd.tar
# todo: prune build-deps (e.g: go)
#rm -f cbsd/go-*.txz
rsync -avz /root/myb-build/myb-extras/ /root/myb-build/cbsd/
#rsync -avz /root/myb-build/jail-skel/ /usr/jails/jails-data/jail1/

[ -d /root/myb-build/cbsd/jail-skel ] && rm -rf /root/myb-build/cbsd/jail-skel
cp -a /root/myb-build/jail-skel /root/myb-build/cbsd/

tar cf cbsd.tar cbsd
xz -T8 cbsd.tar
mv cbsd.tar.xz /usr/jails/jails-data/jail1-data/usr/freebsd-dist/cbsd.txz

# same for /cbsd/ dir + components

cd /usr/jails/jails-data/jail1-data/usr/freebsd-dist
/root/myb-build/scripts/make-manifest.sh *.txz > MANIFEST

#cp -a /root/myb-build/myb-extras/mybinst.sh /usr/jails/jails-data/jail1-data/usr/freebsd-dist/

#cp -a /root/myb-build/auto /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/auto
cp -a /root/myb-build/myb-extras/rc.local /usr/jails/jails-data/jail1-data/etc/
# bhyve uefi fixes:
#cp -a /root/myb-build/bootconfig /usr/jails/jails-data/jail1-data/usr/libexec/bsdinstall/bootconfig

sysrc -qf /usr/jails/jails-data/jail1-data/etc/rc.conf hostname="mybee.my.domain"
