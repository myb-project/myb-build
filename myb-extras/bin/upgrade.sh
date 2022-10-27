#!/bin/sh
. /etc/rc.conf
. /etc/rc.subr
export workdir="${cbsd_workdir}"
. /usr/local/cbsd/cbsd.conf
. /usr/local/cbsd/subr/ansiicolor.subr
. /usr/jails/nc.inventory
. /usr/local/cbsd/subr/nc.subr

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
clear

echo
${ECHO} "${H1_COLOR} *** [MyBee upgrade script] *** ${N0_COLOR}"
echo
${ECHO} "${H2_COLOR} pkg update ${N0_COLOR}"
echo

env IGNORE_OSVERSION=yes SIGNATURE_TYPE=none ASSUME_ALWAYS_YES=yes pkg update -f

# todo: save old version
echo
${ECHO} "${H2_COLOR} pkg upgrade ${N0_COLOR}"
echo

env ASSUME_ALWAYS_YES=yes IGNORE_OSVERSION=yes pkg upgrade -U -y

# todo: check for version changes
echo
${ECHO} "${H2_COLOR} update modules ${N0_COLOR}"
echo

/usr/local/myb/mybinst.sh
