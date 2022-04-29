#!/bin/sh
mybbasever="13.1"
jname="micro1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

[ -r /usr/jails/export/micro1.img ] && rm -f /usr/jails/export/micro1.img
cbsd jexport micro1
