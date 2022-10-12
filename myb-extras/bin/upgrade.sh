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

[ -d /usr/local/www/public ] && rm -rf /usr/local/www/public
cp -a /usr/local/myb/myb-public/public /usr/local/www/

# refresh modules
[ -d /usr/local/cbsd/modules/myb.d ] && rm -rf /usr/local/cbsd/modules/myb.d
[ -d /usr/local/cbsd/modules/garm.d ] && rm -rf /usr/local/cbsd/modules/garm.d
[ -d /usr/local/cbsd/modules/api.d ] && rm -rf /usr/local/cbsd/modules/api.d
[ -d /usr/local/cbsd/modules/k8s.d ] && rm -rf /usr/local/cbsd/modules/k8s.d
# garm.d
cp -a /usr/local/myb/garm.d /usr/local/cbsd/modules/
rm -rf /usr/local/cbsd/modules/garm.d/.git || true
# myb.d
cp -a /usr/local/myb/myb.d /usr/local/cbsd/modules/
rm -rf /usr/local/cbsd/modules/myb.d/.git || true
# k8s.d
cp -a /usr/local/myb/k8s.d /usr/local/cbsd/modules/
rm -rf /usr/local/cbsd/modules/k8s.d/.git || true
[ -d /root/myb-build/myb-extras/k8s.d/share/k8s-system-default ] && rm -rf /root/myb-build/myb-extras/k8s.d/share/k8s-system-default
cp -a /root/myb-build/myb-extras/k8s-system-default /root/myb-build/myb-extras/k8s.d/share/
# api.d
cp -a /usr/local/myb/api.d /usr/local/cbsd/modules/
rm -rf /usr/local/cbsd/modules/api.d/.git || true

[ ! -d /usr/local/etc/pkg/repos ] && mkdir -p /usr/local/etc/pkg/repos
cp -a /usr/local/myb/pkg/Mybee-latest.conf /usr/local/etc/pkg/repos/

### NGINX merge?

[ ! -d /usr/jails/etc ] && mkdir /usr/jails/etc
cat > /usr/jails/etc/modules.conf <<EOF
pkg.d				# MyBee auto-setup
bsdconf.d			# MyBee auto-setup
zfsinstall.d			# MyBee auto-setup
api.d				# MyBee auto-setup
myb.d				# MyBee auto-setup
k8s.d				# MyBee auto-setup
garm.d				# MyBee auto-setup
EOF

# for DFLY
cat > /usr/jails/etc/cloud-init-extras.conf <<EOF
cbsd_cloud_init=1		# MyBee auto-setup
EOF

cp -a /usr/local/myb/myb-os-release /usr/local/etc/rc.d/myb-os-release

# MERGE instead of copy
cp -a /usr/local/cbsd/modules/api.d/etc/api.conf ~cbsd/etc/
cp -a /usr/local/myb/bhyve-api.conf ~cbsd/etc/
cp -a /usr/local/cbsd/modules/api.d/etc/jail-api.conf ~cbsd/etc/
cp -a /usr/local/myb/cbsd_api_cloud_images.json /usr/local/etc/cbsd_api_cloud_images.json
cp -a /usr/local/myb/syslog.conf /etc/syslog.conf

rsync -avz /usr/local/myb/bin/ /root/bin/

/usr/local/bin/rsync -avz /usr/local/myb/jail-skel/ /

# diff order with mybinst.sh
/root/bin/auto_ip.sh

# hooks/status update
ln -sf /root/bin/update_cluster_status.sh /usr/jails/share/bhyve-system-default/master_poststop.d/update_cluster_status.sh
ln -sf /root/bin/update_cluster_status.sh /usr/jails/share/bhyve-system-default/master_poststart.d/update_cluster_status.sh
ln -sf /root/bin/route_del.sh /usr/jails/share/bhyve-system-default/master_poststop.d/route_del.sh
ln -sf /root/bin/route_add.sh /usr/jails/share/bhyve-system-default/master_poststart.d/route_add.sh

# todo
# /usr/local/bin/cbsd jimport /usr/local/myb/micro1.img
#rm -f /usr/local/myb/micro1.img

echo
${ECHO} "${H2_COLOR} upgrade CBSD ${N0_COLOR}"
echo
export NOINTER=1
export workdir=/usr/jails
/usr/local/cbsd/sudoexec/initenv

exit 0
