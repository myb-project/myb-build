#!/bin/sh
# all-in-one:
#  /usr/local/cbsd/modules/k8s.d/scripts/pv-create.sh -d "${ZFS_K8S_PV_CLUSTER}" -p "${ZFS_K8S_PV_CLUSTER_MNT}" -z "${PV_SPEC_CAPACITY_STORAGE}g" -l /var/log/k8s/pv-create.log
#  /usr/local/cbsd/modules/k8s.d/scripts/nfs-enable.sh -h ${PV_SPEC_SERVER}
#  /usr/local/cbsd/modules/k8s.d/scripts/exports-modify.sh -h "${INIT_MASTERS_IPS} ${INIT_NODES_IPS}" -p ${PV_SPEC_NFS_PATH} -r ${ZFS_K8S_PV_ROOT_MNT}
# e.g.: pv-create-daemon.sh -a "${ZFS_K8S_PV_CLUSTER}" -b "${ZFS_K8S_PV_CLUSTER_MNT}" -c "${PV_SPEC_CAPACITY_STORAGE}g" -d /var/log/k8s/pv-create.log \
#       -e ${PV_SPEC_SERVER} \
#       -f "${INIT_MASTERS_IPS} ${INIT_NODES_IPS}" -g ${PV_SPEC_NFS_PATH} -h ${ZFS_K8S_PV_ROOT_MNT}

while getopts "a:b:c:d:e:f:g:h:" opt; do
	case "${opt}" in
		a) ZFS_K8S_PV_CLUSTER="${OPTARG}" ;;
		b) ZFS_K8S_PV_CLUSTER_MNT="${OPTARG}" ;;
		c) PV_SPEC_CAPACITY_STORAGE="${OPTARG}" ;;
		d) LOG_FILE="${OPTARG}" ;;
		e) PV_SPEC_SERVER="${OPTARG}" ;;
		f) IPS="${OPTARG}" ;;
		g) PV_SPEC_NFS_PATH="${OPTARG}" ;;
		h) ZFS_K8S_PV_ROOT_MNT="${OPTARG}" ;;
	esac
	shift $(($OPTIND - 1))
done

if [ -z "${LOG_FILE}" ]; then
	LOG_FILE="/dev/stdout"
fi

#echo "/usr/local/cbsd/modules/k8s.d/scripts/pv-create.sh -d \"${ZFS_K8S_PV_CLUSTER}\" -p \"${ZFS_K8S_PV_CLUSTER_MNT}\" -z \"${PV_SPEC_CAPACITY_STORAGE}\" -l ${LOG_FILE}"
/usr/local/cbsd/modules/k8s.d/scripts/pv-create.sh -d "${ZFS_K8S_PV_CLUSTER}" -p "${ZFS_K8S_PV_CLUSTER_MNT}" -z "${PV_SPEC_CAPACITY_STORAGE}" -l ${LOG_FILE}
/usr/local/cbsd/modules/k8s.d/scripts/nfs-enable.sh -h ${PV_SPEC_SERVER}
/usr/local/cbsd/modules/k8s.d/scripts/exports-modify.sh -h "${IPS}" -p ${PV_SPEC_NFS_PATH} -r ${ZFS_K8S_PV_ROOT_MNT}

exit 0
