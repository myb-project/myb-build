#!/bin/sh
mybbasever="13.0"
jname="mybee1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

cbsd destroy cbsdfile=${progdir}/CBSDfile || true
cbsd up cbsdfile=${progdir}/CBSDfile ver="${mybbasever}"
cbsd jstop jname=${jname}
