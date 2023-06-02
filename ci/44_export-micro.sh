#!/bin/sh
. /etc/rc.conf          # mybbasever
jname="micro1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

[ -r /usr/jails/export/micro1.img ] && rm -f /usr/jails/export/micro1.img
rm -rf /usr/jails/jails-data/micro1-data/rescue
rm -rf /usr/jails/jails-data/micro1-data/usr/tests

cbsd jexport micro1
