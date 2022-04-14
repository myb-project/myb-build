#!/bin/sh

while getopts "h:" opt; do
	case "${opt}" in
		h) bindip="${OPTARG}" ;;
	esac
        shift $(($OPTIND - 1))
done

if [ -z "${bindip}" ]; then
	echo "usage: $0 -h <bindip>"
	exit 1
fi

# todo: check for record/services already exist

echo "   * modify /etc/rc.conf for service enable..."

#rpc_lockd_enable="YES" \
#nfscbd_enable="YES" \

/usr/sbin/sysrc -qf /etc/rc.conf \
mountd_enable="YES" \
mountd_flags="-r -S -h ${bindip}" \
nfs_server_enable="YES" \
nfs_server_flags="-u -t -h ${bindip}" \
nfsv4_server_enable="YES" \
nfsuserd_enable="YES" \
nfsuserd_flags=" -manage-gids" \
rpcbind_flags="-h ${bindip}" \
rpcbind_enable="YES" > /dev/null 2>&1

for i in mountd nfsuserd rpcbind lockd nfsd; do
	echo "   * restart ${i} service..."
	/usr/sbin/service ${i} restart > /dev/null 2>&1
done

exit 0
