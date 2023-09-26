#!/bin/sh
set +e
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

if [ -d /tmp/mybase ]; then
	umount -f /tmp/mybase/dev > /dev/null 2>&1 || true
	chflags -R noschg /tmp/mybase
	rm -rf /tmp/mybase
fi

cbsd install-pkg-world destdir=/tmp/mybase ver=14.0 cmd_helper=1 packages="FreeBSD-runtime FreeBSD-utilities FreeBSD-ssh FreeBSD-vi FreeBSD-csh FreeBSD-clibs FreeBSD-fetch FreeBSD-libarchive FreeBSD-libbz2 FreeBSD-liblzma FreeBSD-libucl FreeBSD-openssl FreeBSD-zoneinfo FreeBSD-libexecinfo FreeBSD-kernel-cbsd FreeBSD-bootloader FreeBSD-devd FreeBSD-newsyslog FreeBSD-pf FreeBSD-ipfw FreeBSD-geom FreeBSD-syslogd FreeBSD-bhyve FreeBSD-acpi FreeBSD-devmatch FreeBSD-dhclient FreeBSD-bsdinstall FreeBSD-console-tools"
ret=$?
if [ ${ret} -ne 0 ]; then
	echo "install-pkg-world failed"
	exit 1
fi

CHECK_FILES="/tmp/mybase/boot/kernel/kernel \
/tmp/mybase/usr/sbin/bhyve
"

failed=0
for i in ${CHECK_FILES}; do
	if [ ! -x ${i} ]; then
	echo "pkg install failed: no such ${i}"
	exit 1
	fi
done

# check several files

exit 0
