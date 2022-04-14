#!/bin/sh

echo "   * modify /etc/rc.conf for service disable..."

sysrc -qf /etc/rc.conf \
nfsv4_server_enable="NO" \
nfscbd_enable="NO" \
nfsuserd_enable="NO" \
mountd_enable="NO" \
rpc_lockd_enable="NO" \
nfs_server_enable="NO" \
rpcbind_enable="NO" > /dev/null 2>&1

for i in mountd nfsuserd nfsd rpcbind lockd; do
	echo "   * stop ${i} service..."
	/usr/sbin/service ${i} onestop > /dev/null 2>&1
done

exit 0
