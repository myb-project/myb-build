#!/bin/sh
##-- valid sample /etc/exports (todo: maproot to uid per cluster)
# V4: /k8s/pv
#
#/k8s/pv/nfs1 10.0.0.61 -maproot=root
#/k8s/pv/nfs2 10.0.0.62 -maproot=root
##--
pgm="${0##*/}"          # Program basename
progdir="${0%/*}"       # Program directory
: ${REALPATH_CMD=$( which realpath )}
: ${SQLITE3_CMD=$( which sqlite3 )}
: ${RM_CMD=$( which rm )}
: ${MKDIR_CMD=$( which mkdir )}
: ${FORM_PATH="/opt/forms"}
: ${distdir="/usr/local/cbsd"}

MY_PATH="$( ${REALPATH_CMD} ${progdir} )"

# MAIN
if [ -z "${workdir}" ]; then
	[ -z "${cbsd_workdir}" ] && . /etc/rc.conf
	[ -z "${cbsd_workdir}" ] && exit 0
	workdir="${cbsd_workdir}"
fi

set -e
. ${distdir}/cbsd.conf
. ${subrdir}/tools.subr
. ${subr}
set +e

if [ "${1}" != "up" ]; then
	echo "usage: ${pgm} up"
	exit 1
fi

if [ ! -r ${cbsd_workdir}/etc/k8s.conf ]; then
	${ECHO} "${N1_COLOR}please create first: ${N2_COLOR}${cbsd_workdir}/etc/k8s.conf${N0_COLOR}"
	${ECHO} "${N1_COLOR} see example: ${N2_COLOR}/usr/local/cbsd/modules/k8s.d/etc/k8s.conf${N0_COLOR}"
	exit 1
fi

set -e
. ${cbsd_workdir}/etc/k8s.conf
set +e

#set -o xtrace

if ! zpool list ${ZPOOL} > /dev/null 2>&1; then
	echo "no such zpool? ${ZPOOL}"
	exit 1
fi

if ! zfs list ${ZFS_K8S} > /dev/null 2>&1; then
	printf "create ${ZFS_K8S}..."
	if ! zfs create ${ZFS_K8S}; then
		echo "failed"
		exit 1
	else
		echo "ok"
	fi
fi

TMP_MNT=$( zfs get -Hp -o value mountpoint ${ZFS_K8S} 2>/dev/null )
if [ "${TMP_MNT}" != "${ZFS_K8S_MNT}" ]; then
	printf "set mountpoint for ${ZFS_K8S}: ${TMP_MNT} -> ${ZFS_K8S_MNT}: "
	if ! zfs set mountpoint=${ZFS_K8S_MNT} ${ZFS_K8S}; then
		echo "failed"
		exit 1
	else
		zfs mount ${ZFS_K8S} > /dev/null 2>&1 || true
		echo "ok"
	fi
fi

if ! zfs list ${ZFS_K8S} > /dev/null 2>&1; then
	echo "no zfs: ${ZFS_K8S}"
	exit 1
fi

# PV
if ! zfs list ${ZFS_K8S_PV_ROOT} > /dev/null 2>&1; then
	printf "create ${ZFS_K8S_PV_ROOT}..."
	if ! zfs create ${ZFS_K8S_PV_ROOT}; then
		echo "failed"
		exit 1
	else
		echo "ok"
	fi
fi

TMP_MNT=$( zfs get -Hp -o value mountpoint ${ZFS_K8S_PV_ROOT} 2>/dev/null )
if [ "${TMP_MNT}" != "${ZFS_K8S_PV_ROOT_MNT}" ]; then
	printf "set mountpoint for ${ZFS_K8S_PV_ROOT}: ${TMP_MNT} -> ${ZFS_K8S_PV_ROOT_MNT}"
	if ! zfs set mountpoint=${ZFS_K8S_PV_ROOT_MNT} ${ZFS_K8S_PV_ROOT}; then
		echo "failed"
		exit 1
	else
		zfs mount ${ZFS_K8S_PV_ROOT} > /dev/null 2>&1 || true
		echo "ok"
	fi
fi

exit 0
