#!/bin/sh
mybbasever="13.0"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

dstdir=$( mktemp -d )
cbsd cpr pkglist=/root/myb-build/myb.list dstdir=${dstdir}

[ -d ${progdir}/cbsd ] && rm -rf ${progdir}/cbsd
mkdir -p ${progdir}/cbsd

mv ${dstdir}/* ${progdir}/cbsd/

rm -rf ${dstdir}

[ ! -h ${progdir}/cbsd/pkg.pkg ] && exit 1

exit 0
