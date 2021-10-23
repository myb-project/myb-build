#!/bin/sh
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
clear
service netif restart > /dev/null 2>&1
service routing restart > /dev/null 2>&1
echo
echo " *** MyBee post-install script *** "
echo

cd /cbsd
# FIND
#tar xfz pkg-1.17.2.pkg
#/cbsd/usr/local/sbin/pkg-static add -f /cbsd/pkg-1.17.2.pkg
#/cbsd/usr/local/sbin/pkg-static add -f /cbsd/*.pkg

mv /cbsd/api.d /usr/local/cbsd/modules/
# dist cbsd
#rm -rf /usr/local/cbsd
#rm -f /usr/local/bin/cbsd
#mv /cbsd/cbsd-dist /usr/local/cbsd
mv /cbsd/myb-public/public /usr/local/www/

[ ! -d /var/log/cbsdmq ] && mkdir -p /var/log/cbsdmq

echo "=== Initial MyBee setup ==="

hostname=$( sysrc -n 'hostname' )

auto_iface=$( /sbin/route -n get 0.0.0.0 | /usr/bin/awk '/interface/{print $2}' )

if [ -z "${auto_iface}" ]; then
	for i in $( ifconfig -l ); do
		case "${i}" in
			lo*)
				continue
				;;
			*)
				auto_iface="${i}"
				;;
		esac
	done

fi

ip4_addr=$( ifconfig ${auto_iface} 2>/dev/null | /usr/bin/awk '/inet [0-9]+/ { print $2}' | /usr/bin/head -n 1 )

echo "CBSD setup"

#pw useradd cbsd -s /bin/sh -d /usr/jails -c "cbsd user"

cat > /tmp/initenv.conf <<EOF
nodename="${hostname}"
nodeip="${ip4_addr}"
jnameserver="8.8.8.8 8.8.4.4"
nodeippool="10.0.0.0/24"
natip="${ip4_addr}"
nat_enable="pf"
mdtmp="8"
ipfw_enable="1"
zfsfeat="1"
hammerfeat="0"
fbsdrepo="1"
repo="http://bsdstore.ru"
workdir="/usr/jails"
jail_interface="${auto_iface}"
parallel="5"
stable="0"
statsd_bhyve_enable="0"
statsd_jail_enable="0"
statsd_hoster_enable="0"
EOF

echo "SETUP CBSD"
export NOINTER=1 
export workdir=/usr/jails
/usr/local/cbsd/sudoexec/initenv /tmp/initenv.conf

sysrc \
 nginx_enable="YES" \
 cbsdd_enable="YES" \
 clear_tmp_enable="YES" \
 beanstalkd_enable="YES" \
 beanstalkd_flags="-l 127.0.0.1 -p 11300" \
 kld_list="if_bridge vmm if_tap nmdm if_vether" \
 ntpdate_enable="YES" \
 ntpd_enable="YES" \
 ntpd_sync_on_start="YES" \
 cbsd_mq_router_enable="YES" \
 cbsd_mq_api_enable="YES" \
 sshd_enable="YES" \
 sshd_flags="-oUseDNS=no -oPermitRootLogin=without-password -oPort=22" \
 syslogd_enable="NO" \
 sendmail_enable="NO" \
 sendmail_submit_enable="NO" \
 sendmail_outbound_enable="NO" \
 sendmail_msp_queue_enable="NO"


cat > /etc/sysctl.conf <<EOF
security.bsd.see_other_uids = 0
kern.init_shutdown_timeout = 900
security.bsd.see_other_gids = 0
net.inet.icmp.icmplim = 0
net.inet.tcp.fast_finwait2_recycle = 1
net.inet.tcp.recvspace = 262144
net.inet.tcp.sendspace = 262144
kern.ipc.shm_use_phys = 1
kern.ipc.shmall = 262144
kern.ipc.shmmax = 1073741824
kern.maxfiles = 2048000
kern.maxfilesperproc = 200000
net.inet.ip.intr_queue_maxlen = 2048
net.inet.ip.portrange.first = 1024
net.inet.ip.portrange.last = 65535
net.inet.ip.portrange.randomized = 0
net.inet.tcp.maxtcptw = 40960
net.inet.tcp.msl = 10000
net.inet.tcp.nolocaltimewait = 1
net.inet.tcp.syncookies = 1
net.inet.udp.maxdgram = 18432
net.local.stream.recvspace = 262144
net.local.stream.sendspace = 262144
vfs.zfs.prefetch.disable = 1
kern.corefile = /var/coredumps/%N.core
kern.sugid_coredump = 1
kern.ipc.shm_allow_removed = 1
kern.shutdown.poweroff_delay = 500
kern.vt.enable_bell = 0
dev.netmap.buf_size = 24576
net.inet.ip.forwarding = 1
net.inet6.ip6.forwarding = 1
net.inet6.ip6.rfc6204w3 = 1
vfs.nfsd.enable_stringtouid = 1
vfs.nfs.enable_uidtostring = 1
vfs.zfs.min_auto_ashift = 12
security.bsd.see_jail_proc = 0
security.bsd.unprivileged_read_msgbuf = 0
net.bpf.zerocopy_enable = 1
net.inet.raw.maxdgram = 16384
net.inet.raw.recvspace = 16384
net.route.netisr_maxqlen = 2048
net.bpf.optimize_writers = 1
net.inet.ip.redirect = 0
net.inet6.ip6.redirect = 0
hw.intr_storm_threshold = 9000
hw.pci.do_power_nodriver = 3
net.inet.icmp.reply_from_interface = 1
kern.ipc.maxsockbuf = 16777216
EOF


rm -rf /usr/local/etc/nginx
mv /cbsd/nginx /usr/local/etc/

[ ! -d /usr/jails/src/iso ] && mkdir -p /usr/jails/src/iso

[ ! -d /usr/jails/etc ] && mkdir /usr/jails/etc
cat > /usr/jails/etc/modules.conf <<EOF
pkg.d
bsdconf.d
zfsinstall.d
api.d
EOF

env NOINTER=1 /usr/local/bin/cbsd initenv

cat > /etc/rc.local << EOF
# insurance for DHCP-based ifaces
for i in \$( egrep -E '^ifconfig_[aA-zZ]+[0-9]+="DHCP"' /etc/rc.conf | tr "_=" " " | awk '{printf \$2" "}' ); do
	/sbin/dhclient \${i}
done

# restore motd
#cp -a /cbsd/dynmotd.sh /usr/local/bin/
truncate -s0 /etc/motd /var/run/motd /etc/motd.template
#if ! grep -q /usr/local/bin/dynmotd.sh /etc/csh.login 2>/dev/null; then
#	echo '/usr/local/bin/dynmotd.sh' >> /etc/csh.login
#fi
#if ! grep -q /usr/local/bin/dynmotd.sh /etc/profile 2>/dev/null; then
#	echo '/usr/local/bin/dynmotd.sh' >> /etc/profile
#fi

EOF

#cp -a /cbsd/dynmotd.sh /usr/local/bin/
truncate -s0 /etc/motd /var/run/motd /etc/motd.template
#if ! grep -q /usr/local/bin/dynmotd.sh /etc/csh.login 2>/dev/null; then
#	echo '/usr/local/bin/dynmotd.sh' >> /etc/csh.login
#fi
#if ! grep -q /usr/local/bin/dynmotd.sh /etc/profile 2>/dev/null; then
#	echo '/usr/local/bin/dynmotd.sh' >> /etc/profile
#fi

cp -a /usr/local/cbsd/modules/api.d/etc/api.conf ~cbsd/etc/
cp -a /cbsd/bhyve-api.conf ~cbsd/etc/
cp -a /usr/local/cbsd/modules/api.d/etc/jail-api.conf ~cbsd/etc/
cp -a /cbsd/cbsd_api_cloud_images.json /usr/local/etc/cbsd_api_cloud_images.json

sysrc -qf ~cbsd/etc/api.conf server_list="${hostname}"
sysrc -qf ~cbsd/etc/bhyve-api.conf ip4_gw="10.0.0.1"

tube_name=$( echo ${hostname} | tr '.' '_' )

cat > /usr/local/etc/cbsd-mq-router.json <<EOF
{
    "cbsdenv": "/usr/jails",
    "cbsdcolor": false,
    "broker": "beanstalkd",
    "logfile": "/dev/stdout",
    "beanstalkd": {
      "uri": "127.0.0.1:11300",
      "tube": "cbsd_${tube_name}",
      "reply_tube_prefix": "cbsd_${tube_name}_result_id",
      "reconnect_timeout": 5,
      "reserve_timeout": 5,
      "publish_timeout": 5,
      "logdir": "/var/log/cbsdmq"
    }
}
EOF

chown cbsd:cbsd ~cbsd/etc/api.conf
mkdir -p /var/db/cbsd-api /usr/jails/var/db/api/map
chown -R cbsd:cbsd /var/db/cbsd-api /usr/jails/var/db/api/map

# tmp: update CBSD code to latest
#echo "/usr/local/bin/rsync -avz /clonos/bases/cbsd/ /usr/local/cbsd/"
#/usr/local/bin/cbsd initenv inter=0

#mv /clonos/bases/base_* /usr/jails/basejail/
#/usr/local/bin/cbsd register_base arch=amd64 target_arch=amd64 ver=12.0 stable=0
#chflags -R noschg /clonos
#echo "Importing cbsdpuppet jail..."
#/usr/local/bin/cbsd version
#/usr/local/bin/cbsd jimport fs_feat=0 jname=/clonos/bases/cbsdpuppet1.img
#/usr/local/bin/cbsd jset jname=cbsdpuppet1 protected=1
#/usr/local/bin/cbsd jset jname=cbsdpuppet1 hidden=1
#rm -rf /clonos

mkdir /var/coredumps
chmod 0777 /var/coredumps

# temporary fix perms for CBSD 12.0.2 (remove it after 12.0.3 released)
#mkdir /usr/jails/formfile
#chown cbsd:cbsd /usr/jails/formfile
#chmod 0775 /usr/jails/formfile

uplink_iface4=$( /sbin/route -n -4 get 0.0.0.0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )
ip=$( /sbin/ifconfig ${uplink_iface4} | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )

#cat > /usr/local/etc/cbsd-mq-api.json <<EOF
#{
#    "cbsdenv": "/usr/jails",
#    "cbsdcolor": false,
#    "broker": "beanstalkd",
#    "logfile": "/dev/stdout",
#    "recomendation": "/usr/local/cbsd/modules/api.d/misc/recomendation.sh",
#    "freejname": "/usr/local/cbsd/modules/api.d/misc/freejname.sh",
#    "server_url": "http://${ip}",
#    "cloud_images_list": "/usr/local/etc/cbsd_api_cloud_images.json",
#    "iso_images_list": "/usr/local/etc/cbsd_api_iso_images.json",
#    "beanstalkd": {
#      "uri": "127.0.0.1:11300",
#      "tube": "cbsd_zpool1",
#      "reply_tube_prefix": "cbsd_zpool1_result_id",
#      "reconnect_timeout": 5,
#      "reserve_timeout": 5,
#      "publish_timeout": 5,
#      "logdir": "/var/log/cbsdmq"
#    }
#}
#EOF

#sed -i '' -Ees:%%IP%%:${ip}:g /usr/local/www/public/index.html

# set IP for API/public.html/..
/root/bin/auto_ip.sh

#cat > /etc/issue <<EOF
#
# === Welcome to MyBee 21.10 ===
# * API: http://${ip}
# * SSH: ${ip}
#
#EOF

cat > ~cbsd/etc/bhyve-default-default.conf <<EOF
skip_bhyve_init_warning=1
create_cbsdsystem_tap=0
ci_gw4="10.0.0.1"
interface="bridge0"
EOF

mkdir /var/nginx /usr/local/www/status
mv /cbsd/bin /root

cat > /etc/rc.local <<EOF
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
/sbin/ifconfig bridge0 create
/sbin/ifconfig bridge0 10.0.0.1/24 up
#/usr/sbin/valectl -h vale1:vether1
/root/bin/update_cluster_status.sh
EOF

[ ! -d /usr/local/etc/sudoers.d ] && mkdir -m 0755 -p /usr/local/etc/sudoers.d
cat > /usr/local/etc/sudoers.d/10_wheelgroup <<EOF
%wheel ALL=(ALL) NOPASSWD: ALL
EOF

chmod 0440 /usr/local/etc/sudoers.d/10_wheelgroup
/usr/local/bin/rsync -avz /cbsd/jail-skel/ /

#while [ true ]; do
	/usr/bin/wall <<EOF
 MyBee cluster setup complete, reboot host!
EOF
sync
/sbin/reboot
#	sleep 15
#done
