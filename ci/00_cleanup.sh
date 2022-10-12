#!/bin/sh
pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

# cleanup old data
if [ -d ${progdir}/cbsd ]; then
	echo "remove old artifact dir: ${progdir}/cbsd"
	rm -rf ${progdir}/cbsd
fi

mkdir ${progdir}/cbsd

