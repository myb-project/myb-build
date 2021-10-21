#!/bin/sh

. /usr/local/cbsd/subr/ansiicolor.subr

ECHO="echo -e"

check="centos7 centos8 debian10 debian11 freebsd13_ufs freebsd13_zfs freebsd14_ufs freebsd14_zfs netbsd9 openbsd7 opnsense21 oracle7 oracle8 rocky8 ubuntu20"

centos7_iso="/usr/jails/src/iso/cbsd-cloud-CentOS-7.9.0-x86_64-cloud.raw"
centos8_iso="/usr/jails/src/iso/cbsd-cloud-CentOS-stream-8.0-x86_64-cloud.raw"
rocky8_iso="/usr/jails/src/iso/cbsd-cloud-Rocky-8-x86_64-cloud.raw"
oracle7_iso="/usr/jails/src/iso/cbsd-cloud-Oracle-7.9.0-x86_64-cloud.raw"
oracle8_iso="/usr/jails/src/iso/cbsd-cloud-Oracle-8.4.0-x86_64-cloud.raw"
ubuntu20_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Ubuntu-x86-20.04.2.raw"
debian10_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Debian-x86-10.9.1.raw"
debian11_iso="/usr/jails/src/iso/cbsd-cloud-cloud-Debian-x86-11.1.0.raw"
freebsd13_ufs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-ufs-13.0.1-RELEASE-amd64.raw"
freebsd13_zfs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-zfs-13.0.1-RELEASE-amd64.raw"
freebsd14_ufs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-ufs-14-CURRENT-amd64.raw"
freebsd14_zfs_iso="/usr/jails/src/iso/cbsd-cloud-FreeBSD-zfs-14-CURRENT-amd64.raw"
openbsd7_iso="/usr/jails/src/iso/cbsd-cloud-openbsd-70.raw"
netbsd9_iso="/usr/jails/src/iso/cbsd-cloud-netbsd-9.2a.raw"
opnsense21_iso="/usr/jails/src/iso/cbsd-cloud-OPNSense-21-RELEASE-amd64.raw"

for i in ${check}; do
	link=
	eval link="\$${i}_iso"
	found=0
	if [ -n "${link}" ]; then

		if [ -h ${link} ]; then
			vol=
			vol=$( readlink ${link} )

			[ -c ${vol} ] && found=1
		fi
	fi

	if [ ${found} -eq 1 ]; then
		${ECHO} "${N1_COLOR}image for '${N2_COLOR}${i}${N1_COLOR}': ${H3_COLOR}ready${N0_COLOR}"
	else
		${ECHO} "${N1_COLOR}image for '${N2_COLOR}${i}${N1_COLOR}': ${W1_COLOR}not found${N1_COLOR}, please run as root: '${N2_COLOR}${i}${N1_COLOR}'${N0_COLOR}"
	fi

done

exit 0
