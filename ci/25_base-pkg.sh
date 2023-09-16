#!/bin/sh
set +e
. /etc/rc.conf          # mybbasever

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

export OSNAME="MyBee"
cbsd packages ver=${mybbasever} destdir="${progdir}/cbsd"
set -e

exit 0
