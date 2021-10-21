#!/bin/sh
# $1 - size in bytes
conv2human()
{
	local lhal="B"
	local tmpmem="$1"
	local lval

	human_val=""

	for hval in "Kb" "Mb" "Gb"; do
		mem=$(( tmpmem / 1024 ))
		[ "${mem}" = "0" ] && break
		tmpmem=${mem}
		lval="${hval}"
	done

	human_val="${tmpmem} ${lval}"
}

# Calculate free memory
realmem=$( sysctl -n hw.realmem )
tmpmem=${realmem}
page_size=$( sysctl -n vm.stats.vm.v_page_size )
active_count=$( sysctl -n vm.stats.vm.v_active_count )
wire_count=$( sysctl -n vm.stats.vm.v_wire_count )
active_size=$(( page_size * active_count ))
wire_size=$(( page_size * wire_count ))
conv2human ${tmpmem}
TOTAL_MEM="${human_val}"
freemem=$(( realmem - active_size - wire_size ))
conv2human ${freemem}
FREE_MEM="${human_val}"

name=$( hostname )
os=$( sysctl -qn kern.ostype )
CPUName=$( sysctl -qn hw.model )
NCores=$( sysctl -qn hw.ncpu )

uplink_iface4=$( /sbin/route -n -4 get 0.0.0.0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )
uplink_iface6=$( /sbin/route -n -6 get ::0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )

if [ -n "${uplink_iface6}" ]; then
	ip6=$( /sbin/ifconfig ${uplink_iface6} | /usr/bin/awk '/inet6 *:*+/{print $2}' | /usr/bin/grep -v %${uplink_iface6}$ | /usr/bin/head -n1 )
else
	# route can not work in jail, looks at all
	ip6=$( /sbin/ifconfig | /usr/bin/awk '/inet6 *:*+/{print $2}' | /usr/bin/grep -v %${uplink_iface6}$ | /usr/bin/head -n1 )
fi

if [ -n "${uplink_iface4}" ]; then
	ip4=$( /sbin/ifconfig ${uplink_iface4} | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )
else
	# route can not work in jail, looks at all
	ip4=$( /sbin/ifconfig | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )
fi

disks=$( /sbin/sysctl -qn kern.disks )

active_zpool=$( timeout 2 /sbin/zpool get -Ho value name | xargs )

mem=$( echo $TOTAL_MEM' total / '$FREE_MEM' free' )
username=$( whoami )
if [ -e /var/lib/puppet/puppet.info ]; then
	puppetinfo=$( cat /var/lib/puppet/puppet.info )
fi
echo -e "
------------------: System Data :-------------------------------
Hostname:     \033[1;33m$name\033[0m ( ${ip4} ${ip6} )
Kernel:       $(uname -r) ($os)
Uptime:      $(uptime | sed 's/.*up ([^,]*), .*/1/')
CPU:          $CPUName ($NCores cores)
Memory(Mb):   $mem
Active Zpool: ${active_zpool}
------------------------: Logged as: [\033[0;32m$(whoami)\033[0m]  ------------------------------
"
#if Tx=$( /usr/local/bin/tmux ls 2> /dev/null ); then
#	echo -e "\033[0;31mTmux Sessions:\033[0m"
#	echo $Tx
#fi

/root/bin/checkiso.sh
