#!/bin/sh
# -h client IP
# -p NFS mount_point, e.g.: /k8s/pv/k1
# -r NFSv4 root, e.g.: /k8s/pv
while getopts "h:p:r:" opt; do
	case "${opt}" in
		h) hosts="${OPTARG}" ;;
		p) path="${OPTARG}" ;;
		r) root="${OPTARG}" ;;
	esac
	shift $(($OPTIND - 1))
done

if [ -z "${hosts}" ]; then
	echo "usage: $0 -h \"IP1 IP2 IP3\" -p /k8s/pv/k1 -r /k8s/pv"
	exit 1
fi
if [ -z "${path}" ]; then
	echo "usage: $0 - \"IP1 IP2 IP3\" -p /k8s/pv/k1 -r /k8s/pv"
	exit 1
fi
if [ -z "${root}" ]; then
	echo "usage: $0 - \"IP1 IP2 IP3\" -p /k8s/pv/k1 -r /k8s/pv"
	exit 1
fi

# todo: check for ip existance on the host
# todo: check for dir exist (zfs sharenfs)

echo "   * prepare /etc/exports ( $root,$path,$hosts)..."

[ ! -r /etc/exports ] && touch /etc/exports

# maps
search_str="V4: "
if grep -q "${search_str}" /etc/exports; then
	# V4 exist, check for uniq
	search_str="V4: ${root}"

	if ! grep -q "${search_str}" /etc/exports; then
		# not valid V4
		cp -a /etc/exports /etc/exports.bak
		grep -v "V4: " /etc/exports.bak > /etc/exports
		echo "${search_str}" >> /etc/exports
	fi
else
	# not exist
	search_str="V4: ${root}"
	echo "${search_str}" >> /etc/exports
fi

search_str="${root}${path} "
if grep -q "${search_str}" /etc/exports; then
	# path exist
	cp -a /etc/exports /etc/exports.bak
	grep -v "${path} " /etc/exports.bak > /etc/exports
	echo "${path} ${hosts} -maproot=root" >> /etc/exports
else
	# not exist
	echo "${path} ${hosts} -maproot=root" >> /etc/exports
fi

for i in mountd; do
	echo "   * restart ${i} service..."
	/usr/sbin/service ${i} restart > /dev/null 2>&1
done

exit 0
