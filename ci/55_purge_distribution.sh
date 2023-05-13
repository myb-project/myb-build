#!/bin/sh
set +e

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

# golang
echo "$pgm"
ls -la ${progdir}/cbsd/
rm -f ${progdir}/cbsd/go11-*.pkg ${progdir}/cbsd/go12-*.pkg ${progdir}/cbsd/go13-*.pkg ${progdir}/go120*.pkg ${progdir}/go-1.20*.pkg
