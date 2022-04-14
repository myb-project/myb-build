#!/bin/sh
: ${distdir="/usr/local/cbsd"}

# MAIN
if [ -z "${workdir}" ]; then
	[ -z "${cbsd_workdir}" ] && . /etc/rc.conf
	[ -z "${cbsd_workdir}" ] && exit 0
	workdir="${cbsd_workdir}"
fi

[ ! -f "${distdir}/cbsd.conf" ] && exit 1

get_recomendation()
{
	local _conf="${workdir}/etc/k8s.conf"

	. ${_conf}

	if [ -z "${server_list}" ]; then
		echo "No server_list variable. Please add server_list= in ${workdir}/etc/k8s.conf with the corresponding values"
		exit 1
	fi

	num=0
	for i in ${server_list}; do
		num=$(( num + 1 ))
	done

	server_num=${num}

	if [ ${server_num} -eq 1 ]; then
		echo -n "${server_list}"
		exit 0
	fi

	num=1
	if [ -z "${current_srv}" ]; then
		for i in ${server_list}; do
			sysrc -qf ${_conf} current_srv="${i}" > /dev/null 2>&1
			sysrc -qf ${_conf} current_num="${num}" > /dev/null 2>&1
			echo -n "${i}"
			exit 0
		done
	fi

	next_id=
	if [ ${current_num} -eq ${server_num} ]; then
		next_id=1
	else
		next_id=$(( current_num + 1 ))
	fi

	num=1
	for i in ${server_list}; do
		if [ ${num} -eq ${next_id} ]; then
			sysrc -qf ${_conf} current_srv="${i}" > /dev/null 2>&1
			sysrc -qf ${_conf} current_num="${num}" > /dev/null 2>&1
			echo -n "${i}"
			exit 0
		fi
		num=$(( num + 1 ))
	done
	exit 0
}

if [ "${1}" = "lock" ]; then
	shift
	get_recomendation
	exit 0
else
	# recursive execite via lockf wrapper
	lockf -s -t10 /tmp/recomendation.lock /usr/local/cbsd/modules/k8s.d/misc/recomendation.sh lock $*
fi

exit 0
