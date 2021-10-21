#!/bin/sh
# Mock for standalone API without database
# Gen status insead of API.
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

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

	find . -type f -print | while read f; do
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
		. ${f}
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
      "ssh_string": "${ssh_string}"
EOF
echo "n[$num][$all]"
if [ ${num} -eq ${all} ]; then
		cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
    }
EOF
else
		cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
    },
EOF
fi
	done
	cat >> /var/db/cbsd-api/${cid}/vm.list <<EOF
  ],
  "clusters": [
    {
      "total_environment": ${all},
      "total_cpus": 2,
      "total_ram": 2,
      "total_imgsize": 2
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
