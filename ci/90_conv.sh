#!/bin/sh

. /etc/rc.conf          # mybbasever
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

#cp -a /root/myb-build/patch/bootconfig ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/bootconfig

SRC_ROOT="${srcdir}/src_${mybbasever}/src"

# without installworld ;-)
#cp -a ${progdir}/patch/bootconfig ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/bootconfig
cp -a ${progdir}/patch/14x/auto ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/auto

# also not for release (IP address for 172.16. here):
cp -a ${progdir}/patch/14x/netconfig_ipv4 ${workdir}/jails-data/${jname}-data/usr/libexec/bsdinstall/netconfig_ipv4

fs="ufs"
rm -f /tmp/${jname}-${mybbasever}_amd64.img
cbsd jail2iso media=livecd ver=${ver} dstdir=/tmp efi=1 vm_guestfs=${fs} freesize=1024m jname=${jname} applytpl=0
