#!/bin/sh
# Mock for standalone API without database
# Gen status insead of API.
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

conv2human()
{
	local lhal="B"
	local tmpmem="$1"
	local lval

	human_val=

	for hval in "Kb" "Mb" "Gb" "Tb"; do
		mem=$(( tmpmem / 1024 ))
		[ "${mem}" = "0" ] && break
		tmpmem=${mem}
		lval="${hval}"
	done

	human_val="${tmpmem} ${lval}"
}

cores=$( sysctl -n hw.ncpu )

total_mem=$( sysctl -n hw.physmem )
# Calculate free memory
realmem=$( sysctl -n hw.realmem )
tmpmem=${realmem}
page_size=$( sysctl -n vm.stats.vm.v_page_size )
active_count=$( sysctl -n vm.stats.vm.v_active_count )
wire_count=$( sysctl -n vm.stats.vm.v_wire_count )
active_size=$(( page_size * active_count ))
wire_size=$(( page_size * wire_count ))
freemem=$(( realmem - active_size - wire_size ))

eval $( zfs list -Hp ~cbsd/jails-data | awk '{printf "avail="$3" used="$4}' )

dsk1=$( sysctl -n kern.disks |awk '{printf $1}' )
trim=$( diskinfo -v ${dsk1} | grep TRIM |awk '{printf $1}' )

if [ "${trim}" = "No" ]; then
	storage_type="hdd"
else
	storage_type="ssd"
fi

storage_used="${used}"
storage_free="${avail}"
ram_total="${realmem}"
ram_free="${freemem}"
cpu_cores="${cores}"

myfile="status.$$"
tmpfile="/usr/local/www/status/${myfile}"

truncate -s0 ${tmpfile}

SRV=`hostname`

num=1

. /usr/jails/etc/api.conf

cat >> ${tmpfile} <<EOF
<html>
<head>
<title>Cluster status</title>
<meta http-equiv="refresh" content="10">
</head>
<body>
<h3>Global</h3>
<table border=1>
<tr><td>Nodes:</td><td>${num}</td></tr>
<tr><td>Members:</td><td>
EOF

	conv2human ${ram_free}
	ram_free="${human_val}"
	conv2human ${ram_total}
	ram_total="${human_val}"

	conv2human ${storage_free}
	storage_free="${human_val}"
	conv2human ${storage_used}
	storage_used="${human_val}"
	echo "<strong>${SRV}</strong> (cpu: ${cores}, RAM ${ram_free} / ${ram_total}, Storage (${storage_type}): (Free:${storage_free}/Used:${storage_used})<br>" >> ${tmpfile}

if [ -h /var/db/api/tubes ]; then
	cd /var/db/api/tubes
	ACTIVE_TUBES=$( ls -1 | sort |xargs )
	TUBE_STATS=
	TUBE_STATS_FULL=

	for i in ${ACTIVE_TUBES}; do
		cmd_delete=
		total_jobs=
		current_watching=
		current_waiting=
		. /var/db/api/tubes/${i}
		TUBE_STATS="(jobs:${cmd_delete}/${total_jobs},watch/wait:${current_watching}/${current_waiting})"
		if [ -z "${TUBE_STATS_FULL}" ]; then
			TUBE_STATS_FULL="${i} ${TUBE_STATS}<br>"
		else
			TUBE_STATS_FULL="${TUBE_STATS_FULL} ${i} ${TUBE_STATS}<br>"
		fi
	done

	cat >> ${tmpfile} <<EOF
</td></tr>
<tr><td>Active tubes:</td><td>${TUBE_STATS_FULL}</td></tr>
EOF
else
	cat >> ${tmpfile} <<EOF
</td></tr>
<tr><td>Active tubes:</td><td>no data</tr></tr>
EOF
fi

cat >> ${tmpfile} <<EOF
<tr><td>Global ID counter (vm sequence):</td><td>${next_uid}</td></tr>
</table>
EOF

cd /var/db/cbsd-api

echo "<h3>passengers:</h3>" >> ${tmpfile}

echo "<table border=0>">> ${tmpfile}
echo "<tr><td>#</td><td>jname</td><td>profile</td><td>hw</td><td>login:port</td><td>hoster</td><td>gid</td><tr>" >> ${tmpfile}

ls -1 | sort | while read _profile; do

	st1=$( echo ${_profile} | grep -o '^.\{2\}' )
	end1=$( echo ${_profile} | grep -o '.\{2\}$' )

	_obfus_profile="${st1}...${end1}"

	echo "<td colspan=\"6\" align=center><b>${_obfus_profile}</b></td></tr>" >> ${tmpfile}

	if [ -r /var/db/cbsd-api/${_profile}/vm.list ]; then
		cd /var/db/cbsd-api/${_profile}/vms
		id=1
		ls -1 | sort | while read _file; do
			gid=
			hostname=
			host_hostname=
			profile=
			vm_os_type=
			vm_os_profile=
			ver=
			type=
			is_power_on=
			created=
			cpus=
			ram_bytes=
			ram_human=
			imgsize_bytes=
			imgsize_human=
			ssh_user=
			ssh_host=
			ssh_port=
			ssh_string=
			. ${_file}

			case "${type}" in
				container)
					profile="${ver}"
					;;
				vm)
					profile="${vm_os_type}/${vm_os_profile}"
					;;
			esac

			hw="${cpus}/${ram_human}/${imgsize_human}"

			node=$( cat /var/db/cbsd-api/${_profile}/${_file}.node | awk '{printf $1}' )
			echo "<tr><td>${id}</td><td bgcolor=\"#aaff00\">${host_hostname}</td><td>${profile}</td><td>${hw}</td><td bgcolor=\"#dadcdd\">${ssh_string}</td><td>${hostname}</td><td>${gid}</td></tr>" >> ${tmpfile}
			id=$(( id + 1 ))
		done
	fi
done

echo "</table>" >> ${tmpfile}

cd /usr/local/www/status
x=$( readlink status.html )
ln -sf ${myfile} status.html
rm -f $x

exit 0
