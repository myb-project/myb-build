#!/bin/sh
pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

service ntpd stop
ntpdate 0.freebsd.pool.ntp.org
service ntpd start

# cleanup old data
if [ -d ${progdir}/cbsd ]; then
	echo "remove old artifact dir: ${progdir}/cbsd"
	rm -rf ${progdir}/cbsd
fi

mkdir ${progdir}/cbsd

for i in cpr3e421 cprd07dc cpr9ca75 mybee1 micro1; do
	cbsd jremove ${i}
done

exit 0
