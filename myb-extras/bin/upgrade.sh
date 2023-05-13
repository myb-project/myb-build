#!/bin/sh
. /etc/rc.conf
. /etc/rc.subr
export workdir="${cbsd_workdir}"
. /usr/local/cbsd/cbsd.conf
. /usr/local/cbsd/subr/ansiicolor.subr
. /usr/jails/nc.inventory
. /usr/local/cbsd/subr/nc.subr
. /usr/jails/cmd.subr

# MAIN
web=0
check_for_updates=0

while getopts "c:w:" opt; do
	case "${opt}" in
		c) check_for_updates="${OPTARG}" ;;
		w) web="${OPTARG}:" ;;
	esac
	shift $(($OPTIND - 1))
done

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
clear

cur_time=$( ${DATE_CMD} +%s )
last_check_update=
[ -r /var/spool/myb/state.conf ] && . /var/spool/myb/state.conf

PKG_CMD=$( which pkg )
echo

${ECHO} "${H1_COLOR} *** [Check for updates] *** ${N0_COLOR}"

if [ -n "${last_check_update}" ]; then
	check_diff=$(( cur_time - last_check_update ))
else
	check_diff=99999
fi

if [ ${check_diff} -lt 1200 -a -r /var/spool/myb/last_result.txt ]; then
	${CAT_CMD} /var/spool/myb/last_result.txt
	exit 0
fi

# queue
[ -r /usr/jails/etc/cbsd_queue.conf ] && . /usr/jails/etc/cbsd_queue.conf
[ -r /usr/jails/nc.inventory ] && . /usr/jails/nc.inventory


logfile=$( ${MKTEMP_CMD} )
trap "[ -r ${logfile} ] && ${RM_CMD} -f ${logfile}" HUP INT ABRT BUS TERM EXIT

if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
	if [ -z "${cbsd_queue_backend}" ]; then
		MOD_CBSD_QUEUE_DISABLED="1"
	else
		[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=10 workdir="${workdir}" jname="0" data_msg="update phase 1/5.."
        fi
fi

env IGNORE_OSVERSION=yes SIGNATURE_TYPE=none ASSUME_ALWAYS_YES=yes timeout 30 ${PKG_CMD} update -f > ${logfile} 2>&1
ret=$?

if [ ${ret} -ne 0 ]; then
	${ECHO} "${W1_COLOR}check-upgrade error:${N0_COLOR}"
	${CAT_CMD} ${logfile}
	if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
		if [ -z "${cbsd_queue_backend}" ]; then
			MOD_CBSD_QUEUE_DISABLED="1"
		else
			[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=0 workdir="${workdir}" jname="0" data_msg="error"
		fi
	fi
	exit 0
fi

[ ! -d /var/spool/myb ] && mkdir /var/spool/myb
echo "last_check_update=\"${cur_time}\"" > /var/spool/myb/state.conf

env IGNORE_OSVERSION=yes SIGNATURE_TYPE=none ${PKG_CMD} upgrade -n -U > /var/spool/myb/last_result.txt

if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
	if [ -z "${cbsd_queue_backend}" ]; then
		MOD_CBSD_QUEUE_DISABLED="1"
	else
		[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=20 workdir="${workdir}" jname="0" data_msg="update phase 2/5.."
	fi
fi

if [ ${check_for_updates} -eq 1 ]; then
	[ -r /var/spool/myb/last_result.txt ] && ${CAT_CMD} /var/spool/myb/last_result.txt
	exit 0
fi

${ECHO} "${H1_COLOR} *** [Upgrade] *** ${N0_COLOR}"
echo

if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
	if [ -z "${cbsd_queue_backend}" ]; then
		MOD_CBSD_QUEUE_DISABLED="1"
	else
		[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=40 workdir="${workdir}" jname="0" data_msg="update phase 3/5.."
	fi
fi

env ASSUME_ALWAYS_YES=yes IGNORE_OSVERSION=yes pkg upgrade -U -y

# todo: check for version changes
echo
${ECHO} "${H2_COLOR} update modules ${N0_COLOR}"
echo

if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
	if [ -z "${cbsd_queue_backend}" ]; then
		MOD_CBSD_QUEUE_DISABLED="1"
	else
		[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=60 workdir="${workdir}" jname="0" data_msg="update phase 4/5.."
	fi
fi


/usr/local/myb/mybinst.sh -w ${web}
ret=$?

if [ "${mod_cbsd_queue_enabled}" = "YES" -a -z "${MOD_CBSD_QUEUE_DISABLED}" ]; then
	if [ -z "${cbsd_queue_backend}" ]; then
		MOD_CBSD_QUEUE_DISABLED="1"
	else
		[ -n "${cbsd_jail_queue_name}" ] && /usr/local/bin/cbsd ${cbsd_queue_backend} cbsd_queue_name=${cbsd_settings_queue_name} id=update cmd=update status=90 workdir="${workdir}" jname="0" data_msg="update phase 5/5.."
	fi
fi

# drop cache
[ -r /tmp/cix_upgrade_latest.conf ] && rm -f /tmp/cix_upgrade_latest.conf

/root/bin/web_upgrade listjson

# save timestamp for last upgrade?

exit 0
