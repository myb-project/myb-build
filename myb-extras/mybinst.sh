#!/bin/sh
# TODO: sync with upgrade.sh
#
OPATH="${PATH}"
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# grafefull restart for WEB services?
web=0

while getopts "w:" opt; do
	case "${opt}" in
		w) web="1" ;;
	esac
	shift $(($OPTIND - 1))
done

myb_firstboot="1"				# already initialized ?
[ -r /etc/rc.conf ] && . /etc/rc.conf
if [ -z "${myb_default_network}" ]; then
	myb_default_network="10.0.101"
	/usr/sbin/sysrc -qf /etc/rc.conf myb_default_network="${myb_default_network}" > /dev/null 2>&1
fi

if [ ${myb_firstboot} -eq 1 ]; then
	clear
	service netif restart > /dev/null 2>&1
	service routing restart > /dev/null 2>&1
	echo
	echo " *** [MyBee post-install script] *** "
	echo

	# change password root shell
	pw usermod -s /bin/csh -n root

	# depending on the presence of an unprivileged extra user,
	# we allow or deny remote login for root
	# For FreeBSD 13.1-RELEASE we have 27 users after install + 'cbsd' = 28
	#nobody:*:65534:65534::0:0:Unprivileged user:/nonexistent:/usr/sbin/nologin
	#cbsd:*:150:150::0:0:Cbsd user:/usr/jails:/bin/sh
	#cyrus:*:60:60::0:0:the cyrus mail server:/nonexistent:/usr/sbin/nologin
	# 29
	users_num=$( grep -v '^#' /etc/master.passwd | wc -l | awk '{printf $1}' )
	if [ "${users_num}" != "28" ]; then
		SSH_ROOT_ENABLED=0
		echo "[${users_num}] Default SSH ROOT access: disabled" | tee -a /var/log/mybinst.log
	else
		SSH_ROOT_ENABLED=1
		echo "[${users_num}] Default SSH ROOT access: enabled" | tee -a /var/log/mybinst.log
	fi
	echo

	if [ "${myb_manage_loaderconf}" != "NO" ]; then
		# tune loader.conf
		cat >> /boot/loader.conf <<EOF
loader_menu_title="Welcome to MyBee Project"

module_path="/boot/kernel;/boot/modules;/boot/dtb;/boot/dtb/overlays"
vmm_load="YES"
#vfs.zfs.arc_max = "512M"
aesni_load="YES"
ipfw_load="YES"
net.inet.ip.fw.default_to_accept=1
cpuctl_load="YES"
pf_load="YES"
kern.racct.enable=1
ipfw_nat_load="YES"
libalias_load="YES"
sem_load="YES"
coretemp_load="YES"
cc_htcp_load="YES"
#aio_load="YES"

kern.ipc.semmnu=120
kern.ipc.semume=40
kern.ipc.semmns=240
kern.ipc.semmni=40
kern.ipc.shmmaxpgs=65536

net.inet.tcp.syncache.hashsize=1024
net.inet.tcp.syncache.bucketlimit=512
net.inet.tcp.syncache.cachelimit=65536
net.inet.tcp.hostcache.hashsize=16384
net.inet.tcp.hostcache.bucketlimit=100
net.inet.tcp.hostcache.cachelimit=65536

kern.nbuf=128000
net.inet.tcp.tcbhashsize=524288
net.inet.tcp.hostcache.bucketlimit=120
net.inet.tcp.tcbhashsize=131072

impi_load="YES"
accf_data_load="YES"
accf_dns_load="YES"
accf_http_load="YES"

vm.pmap.pti="0"
hw.ibrs_disable="1"
crypto_load="YES"

# 
if_bnxt_load="YES"
if_qlnxe_load="YES"

### Use next-gen MRSAS drivers in place of MFI for device supporting it
# This solves lot of [mfi] COMMAND 0x... TIMEOUT AFTER ## SECONDS
hw.mfi.mrsas_enable="1"

### Tune some global values ###
hw.usb.no_pf="1"        # Disable USB packet filtering

# Load The DPDK Longest Prefix Match (LPM) modules
dpdk_lpm4_load="YES"
dpdk_lpm6_load="YES"

# Load DXR: IPv4 lookup algo
fib_dxr_load="YES"

# Loading newest Intel microcode
cpu_microcode_load="YES"
cpu_microcode_name="/boot/firmware/intel-ucode.bin"

### Intel NIC tuning ###
# https://bsdrp.net/documentation/technical_docs/performance#nic_drivers_tuning
# Don't limit the maximum of number of received packets to process at a time
hw.igb.rx_process_limit="-1"
hw.em.rx_process_limit="-1"
hw.ix.rx_process_limit="-1"
# Allow unsupported SFP
hw.ix.unsupported_sfp="1"
hw.ix.allow_unsupported_sfp="1"

### Chelsio NIC tuning ###
# Prevent to reserve ASIC ressources unused on a router/firewall,
# improve performance when we will reach 10Mpps or more
hw.cxgbe.toecaps_allowed="0"
hw.cxgbe.rdmacaps_allowed="0"
hw.cxgbe.iscsicaps_allowed="0"
hw.cxgbe.fcoecaps_allowed="0"

# Under network heavy usage, network critical traffic (mainly
# non-RSS traffic like ARP, LACP) could be droped and flaping LACP links.
# To mitigate this situation, Chelsio could reserves one TX queue for
# non-RSS traffic with this tuneable:
# hw.cxgbe.rsrv_noflowq="1"
# But compensate the number of TX queue by increasing it by one.
# As example, if you had 8 queues, uses now 9:
# hw.cxgbe.ntxq="9"

### link tunning ###
# Increase interface send queue length
# lagg user: This value should be at minimum the sum of txd buffer of each NIC in the lagg
# hw.ix.txd: 2048 by default, then use x4 here (lagg with 4 members)
net.link.ifqmaxlen="16384"

# Avoid message netisr_register: epair requested queue limit 688128 capped to net.isr.maxqlimit 1024
net.isr.maxqlimit=1000000

# Use all cores for netisr processing
net.isr.maxthreads=-1
EOF
	fi

fi

# Upgrade area

[ ! -d /usr/local/etc/pkg/repos ] && mkdir -p /usr/local/etc/pkg/repos
cp -a /usr/local/myb/pkg/Mybee-latest.conf /usr/local/etc/pkg/repos/
# when no network?
pkg info cbsd > /dev/null 2>&1
remote_install=$?

if [ ${remote_install} -eq 1 ]; then
	echo "Remote upgrade: pkg update -f ..."
	env IGNORE_OSVERSION=yes SIGNATURE_TYPE=none pkg update -f
fi

## Remote install by list
if [ -r /usr/local/myb/myb.list ]; then

	install_list=$( grep -v '^#' /usr/local/myb/myb.list | sed 's:/usr/ports/::g' | while read _pkg; do
		pkg info ${_pkg} > /dev/null 2>&1 || printf "${_pkg} "
	done )

	if [ -n "${install_list}" ]; then
		echo "Remote upgrade: install dependencies: ${install_list} ..."
		#pkg install -r MyBee-latest -y -f cbsd ${install_list}
		env SIGNATURE_TYPE=none ASSUME_ALWAYS_YES=yes IGNORE_OSVERSION=yes pkg install -y -f cbsd ${install_list}
		env SIGNATURE_TYPE=none ASSUME_ALWAYS_YES=yes IGNORE_OSVERSION=yes pkg upgrade -r MyBee-latest -y
	fi
fi

if [ ${myb_firstboot} -eq 0 ]; then
	# upgrade from repo
	env SIGNATURE_TYPE=none ASSUME_ALWAYS_YES=yes IGNORE_OSVERSION=yes pkg upgrade -r MyBee-latest -y
fi

[ -d /usr/local/cbsd/modules/api.d ] && rm -rf /usr/local/cbsd/modules/api.d
cp -a /usr/local/myb/api.d /usr/local/cbsd/modules/

[ -d /usr/local/cbsd/modules/myb.d ] && rm -rf /usr/local/cbsd/modules/myb.d
cp -a /usr/local/myb/myb.d /usr/local/cbsd/modules/

[ -d /usr/local/cbsd/modules/garm.d ] && rm -rf /usr/local/cbsd/modules/garm.d
cp -a /usr/local/myb/garm.d /usr/local/cbsd/modules/

[ -d /usr/local/cbsd/modules/convectix.d ] && rm -rf /usr/local/cbsd/modules/convectix.d
cp -a /usr/local/myb/convectix.d /usr/local/cbsd/modules/

[ -d /usr/local/cbsd/modules/k8s.d ] && rm -rf /usr/local/cbsd/modules/k8s.d
cp -a /usr/local/myb/k8s.d /usr/local/cbsd/modules/

[ ! -d /var/log/cbsdmq ] && mkdir -p /var/log/cbsdmq

## Upgrade area

echo "=== Initial MyBee setup ==="

hostname=$( /usr/sbin/sysrc -n hostname 2>/dev/null | awk '{printf $1}' )

auto_iface=$( /sbin/route -n get 0.0.0.0 | /usr/bin/awk '/interface/{print $2}' )

if [ -z "${auto_iface}" ]; then
	for i in $( ifconfig -l ); do
		case "${i}" in
			lo*)
				continue
				;;
			*)
				auto_iface="${i}"
				break
				;;
		esac
	done
fi

ip4_addr=$( ifconfig ${auto_iface} 2>/dev/null | /usr/bin/awk '/inet [0-9]+/ { print $2}' | /usr/bin/head -n 1 )


## when no IP?
[ -z "${ip4_addr}" ] && ip4_addr="${myb_default_network}.1"

echo "CBSD setup"

#pw useradd cbsd -s /bin/sh -d /usr/jails -c "cbsd user"

cat > /tmp/initenv.conf <<EOF
nodename="${hostname}"
nodeip="${ip4_addr}"
jnameserver="8.8.8.8 8.8.4.4"
nodeippool="${myb_default_network}.0/24"
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

cp -a /tmp/initenv.conf /root

echo "SETUP CBSD"
export NOINTER=1
export workdir=/usr/jails

/usr/local/cbsd/sudoexec/initenv /tmp/initenv.conf >> /var/log/cbsd_init.log 2>&1

[ ! -r ~cbsd/etc/cbsd-pf.conf ] && /usr/bin/touch ~cbsd/etc/cbsd-pf.conf
/usr/sbin/sysrc -qf ~cbsd/etc/cbsd-pf.conf cbsd_nat_skip_natip_network=1

#  sshd_flags="-oUseDNS=no -oPermitRootLogin=without-password -oPort=22" \
/usr/sbin/sysrc \
 netwait_enable="YES" \
 cbsdd_enable="YES" \
 clear_tmp_enable="YES" \
 beanstalkd_enable="YES" \
 beanstalkd_flags="-l 127.0.0.1 -p 11300 -z 104856" \
 kld_list="if_bridge vmm if_tap nmdm if_vether" \
 ntpdate_enable="YES" \
 ntpd_enable="YES" \
 ntpd_sync_on_start="YES" \
 cbsd_mq_router_enable="YES" \
 cbsd_mq_api_enable="YES" \
 cbsd_mq_api_flags="-listen 127.0.0.1:65531 -cluster_limit=10" \
 sshd_enable="YES" \
 syslogd_enable="NO" \
 sendmail_enable="NO" \
 sendmail_submit_enable="NO" \
 sendmail_outbound_enable="NO" \
 sendmail_msp_queue_enable="NO" \
 cloned_interfaces="bridge100" \
 ifconfig_bridge100="inet ${myb_default_network}.1/24 up" \
 osrelease_enable="NO" \
 mybosrelease_enable="YES" \
 moused_nondefault_enable="NO" \
 cbsd_workdir="/usr/jails" \
 utx_enable="NO" \
 mixer_enable="NO" \
 rc_startmsgs="NO" \
 linux_mounts_enable="NO" \
 rctl_enable="NO"

if [ "${myb_manage_nginx}" != "NO" ]; then
	/usr/sbin/sysrc nginx_enable="YES"
fi

if [ ${myb_firstboot} -eq 1 ]; then
	if [ ${SSH_ROOT_ENABLED} -eq 0 ]; then
		echo "extra users exist, disable SSH root login by default"
		/usr/sbin/sysrc -qf /etc/rc.conf sshd_flags="-oUseDNS=no -oPermitRootLogin=no -oPort=22" > /dev/null 2>&1
	else
		echo "extra users does not exist, enable SSH root login by default"
		/usr/sbin/sysrc -qf /etc/rc.conf sshd_flags="-oUseDNS=no -oPermitRootLogin=yes -oPort=22" > /dev/null 2>&1
	fi
fi

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

if [ "$myb_manage_nginx}" != "NO" ]; then
	if [ ${myb_firstboot} -eq 1 ]; then
		rm -rf /usr/local/etc/nginx
		mv /usr/local/myb/nginx /usr/local/etc/
	fi
fi

[ ! -d /usr/jails/src/iso ] && mkdir -p /usr/jails/src/iso

[ ! -d /usr/jails/etc ] && mkdir /usr/jails/etc
cat > /usr/jails/etc/modules.conf <<EOF
pkg.d				# MyBee auto-setup
bsdconf.d			# MyBee auto-setup
zfsinstall.d		# MyBee auto-setup
api.d				# MyBee auto-setup
myb.d				# MyBee auto-setup
k8s.d				# MyBee auto-setup
garm.d				# MyBee auto-setup
EOF

# for DFLY
cat > /usr/jails/etc/cloud-init-extras.conf <<EOF
cbsd_cloud_init=1		# MyBee auto-setup
EOF

env NOINTER=1 /usr/local/bin/cbsd initenv

if [ "${myb_manage_rclocal}" != "NO" ]; then
cat > /etc/rc.local << EOF
# insurance for DHCP-based ifaces
for i in \$( egrep -E '^ifconfig_[aA-zZ]+[0-9]+="DHCP"' /etc/rc.conf | tr "_=" " " | awk '{printf \$2" "}' ); do
	/sbin/dhclient \${i}
done

truncate -s0 /etc/motd /var/run/motd /etc/motd.template
EOF
fi

cp -a /usr/local/myb/myb-os-release /usr/local/etc/rc.d/myb-os-release

cp -a /usr/local/myb/api.d/etc/api.conf ~cbsd/etc/
cp -a /usr/local/myb/bhyve-api.conf ~cbsd/etc/
cp -a /usr/local/myb/api.d/etc/jail-api.conf ~cbsd/etc/

cp -a /usr/local/myb/cbsd_api_cloud_images.json /usr/local/etc/cbsd_api_cloud_images.json
cp -a /usr/local/myb/syslog.conf /etc/syslog.conf

# dup ?
[ ! -r ~cbsd/etc/cbsd-pf.conf ] && /usr/bin/touch -s0 ~cbsd/etc/cbsd-pf.conf
/usr/sbin/sysrc -qf ~cbsd/etc/cbsd-pf.conf cbsd_nat_skip_natip_network=1

/usr/sbin/sysrc -qf ~cbsd/etc/api.conf server_list="${hostname}"
/usr/sbin/sysrc -qf ~cbsd/etc/bhyve-api.conf ip4_gw="${myb_default_network}.1"

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

cat > /usr/jails/etc/k8s.conf <<EOF
ZPOOL=zroot
ZFS_K8S="${ZPOOL}/k8s"
ZFS_K8S_MNT="/k8s"
api_env_name="env"
server_list="${tube_name}"
PV_SPEC_SERVER="${myb_default_network}.1"

ZPOOL="zroot"
ZFS_K8S="\${ZPOOL}/k8s"
ZFS_K8S_MNT="/k8s"
ZFS_K8S_PV_ROOT="\${ZFS_K8S}/pv"                         # zpool root PV
ZFS_K8S_PV_ROOT_MNT="\${ZFS_K8S_MNT}/pv"                 # zpool mnt root PV

EOF

cat > /usr/jails/etc/k8world.conf <<EOF
K8S_MK_JAIL="1"
EOF

chown cbsd:cbsd ~cbsd/etc/api.conf ~cbsd/etc/k8s.conf /usr/jails/etc/k8world.conf
[ ! -d /var/db/cbsd-api ] && mkdir -p /var/db/cbsd-api 
[ ! -d /usr/jails/var/db/api/map ] && mkdir -p /usr/jails/var/db/api/map
chown -R cbsd:cbsd /var/db/cbsd-api /usr/jails/var/db/api/map

[ ! -d /var/coredumps ] && mkdir /var/coredumps
chmod 0777 /var/coredumps

uplink_iface4=$( /sbin/route -n -4 get 0.0.0.0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )
ip=$( /sbin/ifconfig ${uplink_iface4} | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )

# set IP for API/public.html/..
[ ! -d /usr/local/www/public ] && mkdir -p /usr/local/www/public
rsync -avz --exclude nubectl /usr/local/myb/myb-public/public/ /usr/local/www/public/
rsync -avz /usr/local/myb/bin/ /root/bin/
[ -x /root/bin/auto_ip.sh ] && /root/bin/auto_ip.sh

cat > ~cbsd/etc/bhyve-default-default.conf <<EOF
skip_bhyve_init_warning=1
create_cbsdsystem_tap=0
ci_gw4="${myb_default_network}.1"
interface="bridge100"
EOF

if [ "${myb_manage_nginx}" != "NO" ]; then
	[ ! -d /var/nginx ] && mkdir /var/nginx
fi
[ ! -d /usr/local/www/status ] && mkdir /usr/local/www/status

if [ "${myb_manage_sudo}" != "NO" ]; then
	[ ! -d /usr/local/etc/sudoers.d ] && mkdir -m 0755 -p /usr/local/etc/sudoers.d
	cat > /usr/local/etc/sudoers.d/10_wheelgroup <<EOF
%wheel ALL=(ALL) NOPASSWD: ALL
EOF

chmod 0440 /usr/local/etc/sudoers.d/10_wheelgroup
/usr/local/bin/rsync -avz /usr/local/myb/jail-skel/ /
fi

# k8s
mkdir -p /var/db/cbsd-k8s /usr/jails/var/db/k8s/map
chown -R cbsd:cbsd /var/db/cbsd-k8s /usr/jails/var/db

# hooks/status update
ln -sf /root/bin/update_cluster_status.sh /usr/jails/share/bhyve-system-default/master_poststop.d/update_cluster_status.sh
ln -sf /root/bin/update_cluster_status.sh /usr/jails/share/bhyve-system-default/master_poststart.d/update_cluster_status.sh
ln -sf /root/bin/route_del.sh /usr/jails/share/bhyve-system-default/master_poststop.d/route_del.sh
ln -sf /root/bin/route_add.sh /usr/jails/share/bhyve-system-default/master_poststart.d/route_add.sh

# in kubernetes bootsrap
#/usr/local/bin/cbsd jimport /usr/local/myb/micro1.img
#rm -f /usr/local/myb/micro1.img

/usr/local/cbsd/sudoexec/initenv > /var/log/cbsd_init2.log 2>&1

/usr/local/cbsd/modules/k8s.d/scripts/install.sh up > /dev/null 2>&1

if [ "${myb_manage_resolv}" != "NO" ]; then
	grep -q 'nameserver' /etc/resolv.conf
	ret=$?
	if [ ${ret} -ne 0 ]; then
		cat >> /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
EOF
	fi
fi

/usr/sbin/sysrc -qf /etc/rc.conf myb_firstboot="0" > /dev/null 2>&1

if [ "${myb_manage_loaderconf}" != "NO" ]; then
	### LOADER.CONF - todo: external helper + dynamic drv finder
	sysrc -qf /boot/loader.conf loader_menu_title="Welcome to MyBee Project"

	#vfs.zfs.arc_max = "512M"
	sysrc -qf /boot/loader.conf aesni_load="YES"
	sysrc -qf /boot/loader.conf ipfw_load="YES"
	sysrc -qf /boot/loader.conf net.inet.ip.fw.default_to_accept=1
	sysrc -qf /boot/loader.conf cpuctl_load="YES"
	sysrc -qf /boot/loader.conf pf_load="YES"
	sysrc -qf /boot/loader.conf vmm_load="YES"
	sysrc -qf /boot/loader.conf kern.racct.enable=1
	sysrc -qf /boot/loader.conf ipfw_nat_load="YES"
	sysrc -qf /boot/loader.conf libalias_load="YES"
	sysrc -qf /boot/loader.conf sem_load="YES"
	sysrc -qf /boot/loader.conf coretemp_load="YES"
	sysrc -qf /boot/loader.conf cc_htcp_load="YES"
	#aio_load="YES"

	# sysrc: hw.cxgbe.fcoecaps_allowed: name contains characters not allowed in shell (dot)
	#sysrc -qf /boot/loader.conf kern.ipc.semmnu=120
	#sysrc -qf /boot/loader.conf kern.ipc.semume=40
	#sysrc -qf /boot/loader.conf kern.ipc.semmns=240
	#sysrc -qf /boot/loader.conf kern.ipc.semmni=40
	#sysrc -qf /boot/loader.conf kern.ipc.shmmaxpgs=65536

	#sysrc -qf /boot/loader.conf net.inet.tcp.syncache.hashsize=1024
	#sysrc -qf /boot/loader.conf net.inet.tcp.syncache.bucketlimit=512
	#sysrc -qf /boot/loader.conf net.inet.tcp.syncache.cachelimit=65536
	#sysrc -qf /boot/loader.conf net.inet.tcp.hostcache.hashsize=16384
	#sysrc -qf /boot/loader.conf net.inet.tcp.hostcache.bucketlimit=100
	#sysrc -qf /boot/loader.conf net.inet.tcp.hostcache.cachelimit=65536

	#sysrc -qf /boot/loader.conf kern.nbuf=128000
	#sysrc -qf /boot/loader.conf net.inet.tcp.tcbhashsize=524288
	#sysrc -qf /boot/loader.conf net.inet.tcp.hostcache.bucketlimit=120
	#sysrc -qf /boot/loader.conf net.inet.tcp.tcbhashsize=131072
	sysrc -qf /boot/loader.conf impi_load="YES"
	sysrc -qf /boot/loader.conf accf_data_load="YES"
	sysrc -qf /boot/loader.conf accf_dns_load="YES"
	sysrc -qf /boot/loader.conf accf_http_load="YES"

	#sysrc -qf /boot/loader.conf vm.pmap.pti="0"
	#sysrc -qf /boot/loader.conf hw.ibrs_disable="1"
	sysrc -qf /boot/loader.conf crypto_load="YES"

	sysrc -qf /boot/loader.conf if_bnxt_load="YES"
	sysrc -qf /boot/loader.conf if_qlnxe_load="YES"

	### Use next-gen MRSAS drivers in place of MFI for device supporting it
	# This solves lot of [mfi] COMMAND 0x... TIMEOUT AFTER ## SECONDS
	#sysrc -qf /boot/loader.conf hw.mfi.mrsas_enable="1"

	### Tune some global values ###
	#sysrc -qf /boot/loader.conf hw.usb.no_pf="1"        # Disable USB packet filtering

	# Load The DPDK Longest Prefix Match (LPM) modules
	#sysrc -qf /boot/loader.conf dpdk_lpm4_load="YES"
	#sysrc -qf /boot/loader.conf dpdk_lpm6_load="YES"

	# Load DXR: IPv4 lookup algo
	sysrc -qf /boot/loader.conf fib_dxr_load="YES"

	# Loading newest Intel microcode
	sysrc -qf /boot/loader.conf cpu_microcode_load="YES"
	sysrc -qf /boot/loader.conf cpu_microcode_name="/boot/firmware/intel-ucode.bin"

	### Intel NIC tuning ###
	# https://bsdrp.net/documentation/technical_docs/performance#nic_drivers_tuning
	# Don't limit the maximum of number of received packets to process at a time
	#sysrc -qf /boot/loader.conf hw.igb.rx_process_limit="-1"
	#sysrc -qf /boot/loader.conf hw.em.rx_process_limit="-1"
	#sysrc -qf /boot/loader.conf hw.ix.rx_process_limit="-1"
	# Allow unsupported SFP
	#sysrc -qf /boot/loader.conf hw.ix.unsupported_sfp="1"
	#sysrc -qf /boot/loader.conf hw.ix.allow_unsupported_sfp="1"

	### Chelsio NIC tuning ###
	# Prevent to reserve ASIC ressources unused on a router/firewall,
	# improve performance when we will reach 10Mpps or more
	#sysrc -qf /boot/loader.conf hw.cxgbe.toecaps_allowed="0"
	#sysrc -qf /boot/loader.conf hw.cxgbe.rdmacaps_allowed="0"
	#sysrc -qf /boot/loader.conf hw.cxgbe.iscsicaps_allowed="0"
	#sysrc -qf /boot/loader.conf hw.cxgbe.fcoecaps_allowed="0"

	# Under network heavy usage, network critical traffic (mainly
	# non-RSS traffic like ARP, LACP) could be droped and flaping LACP links.
	# To mitigate this situation, Chelsio could reserves one TX queue for
	# non-RSS traffic with this tuneable:
	# hw.cxgbe.rsrv_noflowq="1"
	# But compensate the number of TX queue by increasing it by one.
	# As example, if you had 8 queues, uses now 9:
	# hw.cxgbe.ntxq="9"

	### link tunning ###
	# Increase interface send queue length
	# lagg user: This value should be at minimum the sum of txd buffer of each NIC in the lagg
	# hw.ix.txd: 2048 by default, then use x4 here (lagg with 4 members)
	#sysrc -qf /boot/loader.conf net.link.ifqmaxlen="16384"

	# Avoid message netisr_register: epair requested queue limit 688128 capped to net.isr.maxqlimit 1024
	#sysrc -qf /boot/loader.conf net.isr.maxqlimit="1000000"
	#sysrc -qf /boot/loader.conf net.isr.maxthreads="-1"
	####
fi

# legacy firstboot instasll
[ -r /usr/local/etc/rc.d/mybinst.sh ] && rm -f /usr/local/etc/rc.d/mybinst.sh

# sh: /usr/libexec/hyperv/hyperv_vfattach - disable devd-based autoload for hyperv
[ -r /etc/devd/hyperv.conf ] && rm -f /etc/devd/hyperv.conf

if [ ${myb_firstboot} -eq 1 ]; then
/usr/bin/wall <<EOF
  MyBee cluster setup complete, reboot host!
EOF
sync
/sbin/reboot

else
	echo "Restart API, Router, Beanstalkd"
	/usr/sbin/service cbsd-mq-api stop
	/usr/sbin/service cbsd-mq-router stop
	/usr/sbin/service beanstalkd stop
	# 
	/usr/sbin/service beanstalkd start
	/usr/sbin/service cbsd-mq-router start
	/usr/sbin/service cbsd-mq-api start
fi

# drop cache
#[ -r /usr/jails/tmp/bhyve-vm.json ] && /bin/rm -f /usr/jails/tmp/bhyve-vm.json
#[ -r /usr/jails/tmp/bhyve-cloud.json ] && rm -f /usr/jails/tmp/bhyve-cloud.json

#/usr/local/bin/cbsd get_bhyve_profiles src=cloud
#/usr/local/bin/cbsd get_bhyve_profiles src=vm clonos=1
#echo "mybinst.sh done"

exit 0
