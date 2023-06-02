#!/bin/sh
set +e

. /etc/rc.conf          # mybbasever

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

cbsd world ver=${mybbasever}
cbsd kernel ver=${mybbasever}

set -e
[ -d ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue ] && rm -rf ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue

exit 0
