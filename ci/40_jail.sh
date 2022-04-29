#!/bin/sh
mybbasever="13.1"
jname="mybee1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

cbsd destroy cbsdfile=${progdir}/mybee-CBSDfile || true
cbsd destroy cbsdfile=${progdir}/micro-CBSDfile || true

cbsd up cbsdfile=${progdir}/mybee-CBSDfile ver="${mybbasever}"
cbsd jstop jname=mybee1

cbsd up cbsdfile=${progdir}/micro-CBSDfile ver="${mybbasever}"
