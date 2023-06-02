#!/bin/sh
## check for best compress/size/speed val:
. /etc/rc.conf          # mybbasever
jname="mybee1"

pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )
: ${distdir="/usr/local/cbsd"}
[ ! -r "${distdir}/subr/cbsdbootstrap.subr" ] && exit 1
. ${distdir}/subr/cbsdbootstrap.subr || exit 1

SRC_ROOT="${srcdir}/src_${mybbasever}/src"

if [ ! -r ${SRC_ROOT}/Makefile ]; then
	echo "no such src: ${SRC_ROOT}"
	exit 1
fi

cd ${progdir}
if [ -d ${progdir}/myb ]; then
	echo "remove old artifact dir: ${progdir}/myb"
	rm -rf ${progdir}/myb
fi

mkdir ${progdir}/myb

[ -r cbsd.tar ] && rm -f cbsd.tar
# todo: prune build-deps (e.g: go)
#rm -f cbsd/go-*.txz

rsync -avz ${progdir}/myb-extras/ ${progdir}/myb/
rsync -avz ${progdir}/jail-skel/ ${workdir}/jails-data/${jname}/

# in kubernetes bootsrap!
#cp -a /usr/jails/export/micro1.img ${progdir}/myb/

[ -d ${progdir}/myb/jail-skel ] && rm -rf ${progdir}/myb/jail-skel
cp -a ${progdir}/jail-skel ${progdir}/myb/

# Create myb.txz from ${progdir}/myb/
# and copy to /cbsd/

rm -rf /usr/ports/packages/All

make -C /root/myb-build/ports/myb clean
make -C /root/myb-build/ports/myb package
cp -a /usr/ports/packages/All/myb-*.pkg ${progdir}/cbsd/

tar cf cbsd.tar cbsd
xz -T8 cbsd.tar
mv cbsd.tar.xz ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/cbsd.txz

# same for /cbsd/ dir + components

cd ${workdir}/jails-data/${jname}-data/usr/freebsd-dist
${progdir}/scripts/make-manifest.sh *.txz > MANIFEST

#cp -a ${progdir}/myb-extras/mybinst.sh ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/

#cp -a ${progdir}/auto ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/auto
cp -a ${progdir}/myb-extras/rc.local ${workdir}/jails-data/${jname}-data/etc/
# bhyve uefi fixes:
#cp -a ${progdir}/bootconfig ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/bootconfig

sysrc -qf ${workdir}/jails-data/${jname}-data/etc/rc.conf hostname="mybee.my.domain"

