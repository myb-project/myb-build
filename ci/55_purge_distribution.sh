#!/bin/sh
set +e

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

# golang
rm -f ${progdir}/cbsd/go11-*.pkg
