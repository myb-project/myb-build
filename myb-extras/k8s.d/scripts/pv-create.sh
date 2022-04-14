#!/bin/sh
# create PV for cluster
# -d <new ZFS dataset>, e.g.: zroot/k8s/pv/k1
# -p <mount point>, e.g: /k8s/pv/k1
# -z sizem e.g.: 10g
while getopts "d:p:z:l:" opt; do
	case "${opt}" in
		d) ZFS_K8S_PV_CLUSTER="${OPTARG}" ;;
		p) ZFS_K8S_PV_CLUSTER_MNT="${OPTARG}" ;;
		z) PV_SPEC_CAPACITY_STORAGE="${OPTARG}" ;;
		l) LOGFILE="${OPTARG}" ;;
	esac
	shift $(($OPTIND - 1))
done

if [ -z "${LOGFILE}" ]; then
	LOGFILE="/dev/stdout"
fi

DT=$( date "+%Y-%m-%d %H:%M:%S" )
echo "${DT}: $0 $*" >> ${LOGFILE}

if [ -z "${ZFS_K8S_PV_CLUSTER}" ]; then
	echo "usage: $0 -d <new ZFS dataset> -p <mount point> -z <size>" >> ${LOGFILE}
	exit 1
fi
if [ -z "${ZFS_K8S_PV_CLUSTER_MNT}" ]; then
	echo "usage: $0 -d <new ZFS dataset> -p <mount point> -z <size>" >> ${LOGFILE}
	exit 1
fi
if [ -z "${PV_SPEC_CAPACITY_STORAGE}" ]; then
	echo "usage: $0 -d <new ZFS dataset> -p <mount point> -z <size>" >> ${LOGFILE}
	exit 1
fi

echo "  * create PV:" >> ${LOGFILE}

printf "    create ${ZFS_K8S_PV_CLUSTER} ... " >> ${LOGFILE}
if ! zfs list ${ZFS_K8S_PV_CLUSTER} > /dev/null 2>&1; then
	if ! zfs create ${ZFS_K8S_PV_CLUSTER}; then
		echo "failed" >> ${LOGFILE}
		exit 1
	else
		echo "ok" >> ${LOGFILE}
	fi
else
	echo "already exist" >> ${LOGFILE}
fi

TMP_MNT=$( zfs get -Hp -o value mountpoint ${ZFS_K8S_PV_CLUSTER} 2>/dev/null )
printf "    set mountpoint for ${ZFS_K8S_PV_CLUSTER}: ${TMP_MNT} -> ${ZFS_K8S_PV_CLUSTER_MNT} ... " >> ${LOGFILE}

if [ "${TMP_MNT}" != "${ZFS_K8S_PV_CLUSTER_MNT}" ]; then
	if ! zfs set mountpoint=${ZFS_K8S_PV_CLUSTER_MNT} ${ZFS_K8S_PV_CLUSTER}; then
		echo "failed" >> ${LOGFILE}
		exit 1
	else
		zfs mount ${ZFS_K8S_PV_CLUSTER} > /dev/null 2>&1 || true
		echo "ok" >> ${LOGFILE}
	fi
else
	echo "already mounted" >> ${LOGFILE}
fi

chmod 0777 ${ZFS_K8S_PV_CLUSTER_MNT}

if ! zfs list ${ZFS_K8S_PV_CLUSTER} > /dev/null 2>&1; then
	echo "no zfs: ${ZFS_K8S_PV_CLUSTER}" >> ${LOGFILE}
	exit 1
fi

# set quota
printf "    set quota: ${PV_SPEC_CAPACITY_STORAGE} ... " >> ${LOGFILE}
zfs set quota=${PV_SPEC_CAPACITY_STORAGE} ${ZFS_K8S_PV_CLUSTER}
echo "ok" >> ${LOGFILE}

exit 0
