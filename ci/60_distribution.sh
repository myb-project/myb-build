#!/bin/sh
set +e
mybbasever="13.2"
jname="mybee1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

: ${distdir="/usr/local/cbsd"}
[ ! -r "${distdir}/subr/cbsdbootstrap.subr" ] && exit 1
. ${distdir}/subr/cbsdbootstrap.subr || exit 1

SRC_ROOT="${srcdir}/src_${mybbasever}/src"

if [ ! -r ${SRC_ROOT}/Makefile ]; then
	echo "no such src: ${SRC_ROOT}"
	exit 1
fi

cbsd mkdistribution distribution="base kernel" destdir="${workdir}/jails-data/${jname}-data/usr/freebsd-dist"
mv ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/kernel-GENERIC.txz ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/kernel.txz
