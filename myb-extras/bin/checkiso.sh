#!/bin/sh

if [ -n "${1}" ]; then
	checkonly=1
else
	checkonly=0
fi

. /usr/local/cbsd/subr/ansiicolor.subr

ECHO="echo -e"

check="jail alma9 centos7 centos8 centos9 debian10 debian11 dflybsd6 fedora36 fedora37 freebsd13_ufs freebsd13_zfs freebsd14_ufs freebsd14_zfs freefire14_ufs freepbx ghostbsd22 homeass kali2022 k8s netbsd9 openbsd7 opnsense22 oracle7 oracle8 oracle9 rocky8 rocky9 ubuntu20 ubuntu22 ubuntu22_vdi"

jail_iso="/usr/jails/basejail/base_amd64_amd64_13.1/bin/sh"
alma9_iso="/usr/jails/src/iso/cbsd-cloud-Alma-9.1-x86_64-cloud.raw"
centos7_iso="/usr/jails/src/iso/cbsd-cloud-CentOS-7.9.0-x86_64-cloud.raw"
centos8_iso="/usr/jails/src/iso/cbsd-cloud-CentOS-stream-8-20221125-x86_64-cloud.raw"
centos9_iso="/usr/jails/src/iso/cbsd-cloud-CentOS-stream-9-20221123-x86_64-cloud.raw"
rocky8_iso="/usr/jails/src/iso/cbsd-cloud-Rocky-8.7-x86_64-cloud.raw"
rocky9_iso="/usr/jails/src/iso/cbsd-cloud-Rocky-9.1-x86_64-cloud.raw"
oracle7_iso="/usr/jails/src/iso/cbsd-cloud-Oracle-7.9.0-x86_64-cloud.raw"
oracle8_iso="/usr/jails/src/iso/cbsd-cloud-Oracle-8.6.0-x86_64-cloud.raw"
oracle9_iso="/usr/jails/src/iso/cbsd-cloud-Oracle-9.1.0-x86_64-cloud.raw"
ubuntu20_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Ubuntu-x86-20.04.2.raw"
ubuntu22_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Ubuntu-x86-22.04.raw"
ubuntu22_vdi_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Ubuntu-vdi-x86-22.04.raw"
debian10_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Debian-x86-10.9.1.raw"
debian11_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Debian-x86-11.6.0.raw"
dflybsd6_iso="/usr/jails/src/iso/cbsd-cloud-DragonflyBSD-hammer-x64-6.2.2.raw"
fedora36_iso="/usr/jails/src/iso/cbsd-cloud-Fedora-36-x86_64-cloud.raw"
fedora37_iso="/usr/jails/src/iso/cbsd-cloud-Fedora-37-x86_64-cloud.raw"
freebsd13_ufs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-ufs-13.1.0-RELEASE-amd64.raw"
freebsd13_zfs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-zfs-13.1.0-RELEASE-amd64.raw"
freebsd14_ufs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-ufs-14.0.3-CURRENT-amd64.raw"
freebsd14_zfs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-zfs-14.0.3-CURRENT-amd64.raw"
freefire14_ufs_iso="/usr/jails/src/iso/cbsd-cloud-firestarter-ufs-14.0-RELEASE-amd64.raw"
freepbx_iso="/usr/jails/src/iso/cbsd-cloud-FreePBX-16.0-x86_64-cloud.raw"
ghostbsd22_iso="/usr/jails/src/iso/cbsd-cloud-GhostBSD-ufs-x64-22.11-RELEASE-amd64.raw"
homeass_iso="/usr/jails/src/iso/cbsd-cloud-cloud-HomeAssistant-8.raw"
kali2022_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Kali-2022-amd64.raw"
k8s_iso="/usr/jails/src/iso/cbsd-cloud-cloud-kubernetes-26.0.raw"
openbsd7_iso="/usr/jails/src/iso/cbsd-cloud-openbsd-72.raw"
netbsd9_iso="/usr/jails/src/iso/cbsd-cloud-netbsd-9.3.raw"
opnsense22_iso="/usr/jails/src/iso/cbsd-cloud-OPNSense-22.7-RELEASE-amd64.raw"
windows10_ru_iso="/usr/jails/src/iso/cbsd-cloud-windows10ru-cloud.raw"

${ECHO} "${N2_COLOR} Hint: type '<img>' to get image or 'fetch_all.sh' to warm ALL images (Warning! LOTS of traffic)${N0_COLOR}"

for i in ${check}; do
	link=
	eval link="\$${i}_iso"
	found=0

	if [ -n "${link}" ]; then
		case "${i}" in
			jail)
				[ -x ${link} ] && found=1
				;;
			*)
				if [ -h ${link} ]; then
					vol=
					vol=$( readlink ${link} )
					[ -c ${vol} ] && found=1
				fi
				;;
		esac
	fi

	if [ ${found} -eq 1 ]; then
		${ECHO} "${N1_COLOR}image for '${N2_COLOR}${i}${N1_COLOR}': ${H3_COLOR}ready${N0_COLOR}"
	else
		${ECHO} "${N1_COLOR}image for '${N2_COLOR}${i}${N1_COLOR}': ${W1_COLOR}not found${N1_COLOR}, please run as root: '${N2_COLOR}${i}${N1_COLOR}'${N0_COLOR}"
	fi
done

[ ${checkonly} -eq 0 ] && exec /bin/sh

exit 0
