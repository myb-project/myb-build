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

# VM + container
find /var/db/cbsd-api/ -type d -name vms | while read _dir; do
	echo "work dir: ${_dir}"

	num=0
	all=0

	cid=$( realpath ${_dir}/${jname} | cut -d / -f 5 )
	cd /var/db/cbsd-api/${cid}/vms

	all=$( find . -type f -print | while read f; do
		all=$(( all + 1 ))
		echo "${all}"
	done | tail -n1 )


	[ -z "${all}" ] && all=0

	if [ ${all} -eq 0 ]; then
		printf "{}" > /var/db/cbsd-api/${cid}/vm.list
		continue
	fi


	cat > /var/db/cbsd-api/${cid}/vm.list <<EOF
{
  "servers": [
EOF

	total_cpus=0
	total_ram_bytes=0
	totral_imgsize_bytes=0

	eval $( find . -type f -print | while read f; do
		num=$(( num + 1 ))
		gid=
		hostname=
		host_hostname=
		instanceid=
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
		ssh4_string=
		ssh6_string=
		. ${f}

		total_cpus=$(( total_cpus + cpus ))
		total_ram_bytes=$(( total_ram_bytes + ram_bytes ))
		total_imgsize_bytes=$(( total_imgsize_bytes + imgsize_bytes ))

		case "${type}" in
			container)
				profile="${ver}"
				;;
			vm)
				profile="${vm_os_type}/${vm_os_profile}"
				;;
		esac
		hw="${cpus}/${ram_human}/${imgsize_human}"
		#printf "${num}: %-10s %-10s %-10s %-40s\n" ${jname} ${type} ${hw} "${ssh_string}"
		cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
    {
      "instanceid": "${host_hostname}",
      "type": "${type}",
      "profile": "${profile}",
      "hw": "${hw}",
      "ssh_string": "${ssh_string}",
      "ssh4_string": "${ssh4_string}",
      "ssh6_string": "${ssh6_string}"
EOF
if [ ${num} -eq ${all} ]; then
		cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
    }
EOF
else
		cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
    },
EOF
fi

		echo "total_cpus=\"${total_cpus}\""
		echo "total_ram_bytes=\"${total_ram_bytes}\""
		echo "total_imgsize_bytes=\"${total_imgsize_bytes}\""
	done )

	conv2human "${total_ram_bytes}"
	total_ram="${human_val}"
	conv2human "${total_imgsize_bytes}"
	total_imgsize="${human_val}"

	cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
  ],
  "clusters": [
    {
      "total_environment": ${all},
      "total_cpus": ${total_cpus},
      "total_ram_bytes": ${total_ram_bytes},
      "total_ram": "${total_ram}",
      "total_imgsize_bytes": ${total_imgsize_bytes},
      "total_imgsize": "${total_imgsize}"
    }
  ]
}
EOF

	# prune for empty vm.list
	size=$( stat -f "%z" /var/db/cbsd-api/${cid}/vm.list 2>/dev/null )
	if [ "${size}" = "0" ]; then
		rm -rf /var/db/cbsd-api/${cid}
	fi
done

echo "K8S"

# K8S
#/var/db/cbsd-k8s/7760e5e4c53f9c88572293954abce7ff/cluster-test1
find /var/db/cbsd-k8s/ -type d -name vms | while read _dir; do
#	echo "work dir: ${_dir}"

	num=0
	all=0

	cid=$( realpath ${_dir}/${jname} | cut -d / -f 5 )
	cd /var/db/cbsd-k8s/${cid}

	[ ! -d /var/db/cbsd-k8s/${cid} ] && continue

	find . -type f -name cluster-\* -exec realpath {} \; | while read f; do
		# check for dead
		# stat for old ?
		eval $( stat -s ${f} )
		cur_time=$( date +%s )
		difftime=$(( ( cur_time - st_mtime ) / 60 ))
		# check for dead cluster
		if [ ${difftime} -gt 1 ]; then
			k8s_name=$( cat ${f} | awk '{printf $1 }' )
			echo "env: ${k8s_name}"
			echo "[${difftime}]"
			echo "C ${f}"
			k8_exist=$( /usr/local/bin/sqlite3 /usr/jails/var/db/k8s/k8world.sqlite "SELECT k8s_name FROM k8world WHERE k8s_name=\"${k8s_name}\" LIMIT 1" 2>/dev/null | awk '{printf $1}' )
			[ -n "${k8_exist}" ] && continue

			# no k8s here
			echo "No such k8s here: ${k8s_name}: /var/db/cbsd-k8s/${cid}. prune ${f}"
			[ -r /var/db/cbsd-k8s/${cid}/${k8s_name}-bhyve.ssh ] && rm -f /var/db/cbsd-k8s/${cid}/${k8s_name}-bhyve.ssh
			[ -r /var/db/cbsd-k8s/${cid}/${k8s_name}.node ] && rm -f /var/db/cbsd-k8s/${cid}/${k8s_name}.node
			rm -f ${f}
		fi
	done


done

exit 0
