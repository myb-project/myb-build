#!/bin/sh
mybbasever="13.1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

dstdir=$( mktemp -d )

# cleanup old pkg ?
#/var/cache/packages/pkgdir-cpr9ca75 (host) -> /tmp/packages (jail)

echo "cbsd cpr pkglist=/root/myb-build/myb.list dstdir=${dstdir}"
cbsd cpr pkglist=/root/myb-build/myb.list dstdir=${dstdir}

#echo "Sleep: mv ${dstdir}/* ${progdir}/cbsd/"
#read p

mv ${dstdir}/* ${progdir}/cbsd/

rm -rf ${dstdir}

[ ! -h ${progdir}/cbsd/pkg.pkg ] && exit 1

exit 0
