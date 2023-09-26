#!/bin/sh
. /etc/rc.conf          # mybbasever

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

export OSNAME="MyBee"
cbsd world ver=${mybbasever}

world_test_file="/usr/jails/basejail/base_amd64_amd64_${mybbasever}/bin/sh"

if [ ! -r ${world_test_file} ]; then
	echo "no such source: ${world_test_file}"
	exit 1
fi

kernel_test_file="/usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${mybbasever}/boot/kernel/kernel"

cbsd kernel ver=${mybbasever}

if [ ! -r ${kernel_test_file} ]; then
	echo "no such source: ${kernel_test_file}"
	exit 1
fi

#[ -d ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue ] && rm -rf ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue

exit 0
