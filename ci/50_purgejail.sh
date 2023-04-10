#!/bin/sh

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

rm -rf ${workdir}/jails-data/${jname}-data/rescue
rm -rf ${workdir}/jails-data/${jname}-data/tmp/*
rm -rf ${workdir}/jails-data/${jname}-data/usr/include
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/clang
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/dtrace
rm -f ${workdir}/jails-data/${jname}-data/usr/lib/*.a
rm -f ${workdir}/jails-data/${jname}-data/usr/lib/*.o
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib32

rm -rf ${workdir}/jails-data/${jname}-data/usr/share/calendar
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/dict
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/doc
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/dtrace
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/examples
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/games
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/i18n
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/kyua

rm -rf ${workdir}/jails-data/${jname}-data/usr/share/locale/*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/man
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/openssl
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/sendmail
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/snmp

[ ! -f ${workdir}/jails-data/${jname}-data/usr/freebsd-dist ] && mkdir ${workdir}/jails-data/${jname}-data/usr/freebsd-dist

sysrc -qf ${workdir}/jails-data/${jname}-data/etc/rc.conf \
sendmail_enable="NO" \
sendmail_submit_enable="NO" \
sendmail_outbound_enable="NO" \
sendmail_msp_queue_enable="NO" \
syslogd_flags="-ss"

# cron disable
