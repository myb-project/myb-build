#!/bin/sh
set +e

mybbasever="13.1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

cbsd world ver=${mybbasever} && cbsd kernel ver=${mybbasever}
[ -d ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue ] && rm -rf ${workdir}/basejail/base_amd64_amd64_${mybbasever}/rescue
