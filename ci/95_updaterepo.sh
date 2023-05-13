#!/bin/sh
## check for best compress/size/speed val:
mybbasever="13.2"
jname="mybee1"

pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )
: ${distdir="/usr/local/cbsd"}
[ ! -r "${distdir}/subr/cbsdbootstrap.subr" ] && exit 1
. ${distdir}/subr/cbsdbootstrap.subr || exit 1

# lookup for RSYNC
. /etc/rc.conf

if [ -z "${MYB_UPLOAD_132}" ]; then
	echo "no such MYB_UPLOAD_132 string in rc.conf"
	exit 1
fi

[ -z "${PKG_CMD}" ] && PKG_CMD="/usr/sbin/pkg"

# save package list
grep -v '^#' ${progdir}/myb.list | sed 's:/usr/ports/::g' > ${progdir}/myb/myb.list

rm -rf /usr/ports/packages/All
DT=$( date "+%d%H" )
. ${progdir}/myb-extras/version
VER="${myb_version}.${DT}"
sed "s:%%VER%%:${VER}:g" /root/myb-build/ports/myb/Makefile-tpl > /root/myb-build/ports/myb/Makefile

sysrc -qf ${progdir}/myb-extras/version myb_build="${DT}"

make -C /root/myb-build/ports/myb clean
make -C /root/myb-build/ports/myb package
cd /usr/ports/packages/All

mv /usr/ports/packages/All/*.pkg ${progdir}/cbsd/

cp -a ${progdir}/cbsd/*.pkg /usr/ports/packages/All/

${PKG_CMD} repo .

sysrc -qf ${progdir}/cbsd/myb_ver.conf myb_ver_new="${myb_version}.${DT}"

cp -a ${progdir}/cbsd/myb_ver.conf /usr/ports/packages/All/
cp -a ${progdir}/cbsd/myb_ver.json /usr/ports/packages/All/

${RSYNC_CMD} --delete -avz ./ ${MYB_UPLOAD_132}

# retcode
