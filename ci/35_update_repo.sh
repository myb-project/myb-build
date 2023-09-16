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

# lookup for RSYNC
. /etc/rc.conf

if [ -z "${MYB_UPLOAD_140}" ]; then
	echo "no such MYB_UPLOAD_140 string in rc.conf"
	exit 1
fi

ver=${mybbasever%%.*}

if [ ! -h ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest ]; then
	echo "no such ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest symlink to repo"
	exit 1
fi

[ -z "${PKG_CMD}" ] && PKG_CMD="/usr/sbin/pkg"

# save package list
[ ! -d ${progdir}/myb ] && mkdir -p ${progdir}/myb
grep -v '^#' ${progdir}/myb.list | sed 's:/usr/ports/::g' > ${progdir}/myb/myb.list

rsync -avz ${progdir}/myb-extras/ ${progdir}/myb/
rsync -avz ${progdir}/jail-skel/ ${workdir}/jails-data/${jname}/

# in kubernetes bootsrap!
#cp -a /usr/jails/export/micro1.img ${progdir}/myb/

[ -d ${progdir}/myb/jail-skel ] && rm -rf ${progdir}/myb/jail-skel
cp -a ${progdir}/jail-skel ${progdir}/myb/

rm -rf /usr/ports/packages/All
DT=$( date "+%d%H" )
. ${progdir}/myb-extras/version
VER="${myb_version}.${DT}"
sed "s:%%VER%%:${VER}:g" /root/myb-build/ports/myb/Makefile-tpl > /root/myb-build/ports/myb/Makefile

sysrc -qf ${progdir}/myb-extras/version myb_build="${DT}"

make -C /root/myb-build/ports/myb clean
make -C /root/myb-build/ports/myb package
#cd /usr/ports/packages/All

mv /usr/ports/packages/All/*.pkg ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/

#cp -a ${progdir}/cbsd/*.pkg /usr/ports/packages/All/

cd ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest

${PKG_CMD} repo .

sysrc -qf ${progdir}/myb/myb_ver.conf myb_ver_new="${myb_version}.${DT}"

cp -a ${progdir}/cbsd/myb_ver.conf ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/
cp -a ${progdir}/cbsd/myb_ver.json ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/

#echo "${RSYNC_CMD} -avz ./ ${MYB_UPLOAD_140}latest/"
${RSYNC_CMD} -avz --delete ./ ${MYB_UPLOAD_140}latest/

# retcode
