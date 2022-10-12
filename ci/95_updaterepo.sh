#!/bin/sh
## check for best compress/size/speed val:
mybbasever="13.1"
jname="mybee1"

pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )
: ${distdir="/usr/local/cbsd"}
[ ! -r "${distdir}/subr/cbsdbootstrap.subr" ] && exit 1
. ${distdir}/subr/cbsdbootstrap.subr || exit 1

[ -z "${PKG_CMD}" ] && PKG_CMD="/usr/sbin/pkg"

echo "pkg: $PKG_CMD"

# save package list
grep -v '^#' ${progdir}/myb.list | sed 's:/usr/ports/::g' > ${progdir}/myb/myb.list

rm -rf /usr/ports/packages/All
make -C /root/myb-build/ports/myb clean
make -C /root/myb-build/ports/myb package
cd /usr/ports/packages/All

mv /usr/ports/packages/All/*.pkg ${progdir}/cbsd/

cp -a ${progdir}/cbsd/*.pkg /usr/ports/packages/All/

${PKG_CMD} repo .

${RSYNC_CMD} --delete -avz ./ rsync://myb-pkg.convectix.com/Ahth7ailah5eeci1ree6/

