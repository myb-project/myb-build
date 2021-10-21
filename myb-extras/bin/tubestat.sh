#!/bin/sh
# Mock for standalone API without database
# Gen status insead of API.
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
DB_ROOT_DIR="/var/db/api"
[ ! -d ${DB_ROOT_DIR} ] && mkdir -p ${DB_ROOT_DIR}
cd ${DB_ROOT_DIR}

LIST_TUBES=$( echo -e "\r\nlist-tubes\r\nquit\r\n" | timeout 60 nc localhost 11300 | grep '^-' | awk '{printf $2"\n"}' | sort | xargs )
SRV_TUBES=

for i in $LIST_TUBES; do
	case $i in
		default|*_result_id*)
			continue
			;;
		*)
			if [ -z "${SRV_TUBES}" ]; then
				SRV_TUBES="${i}"
			else
				SRV_TUBES="${SRV_TUBES} ${i}"
			fi
			;;
	esac
done

echo "server tubes: $SRV_TUBES"

tmpdir=$( mktemp -d ${DB_ROOT_DIR}/tube.XXXX )
tmpdirname=$( basename ${tmpdir} )

for i in ${SRV_TUBES}; do
	echo -e "\r\nstats-tube ${i}\r\nquit\r\n" | timeout 60 nc localhost 11300  | tr '-' '_' | tr -d " " | tr ":" "=" |grep '=' > ${tmpdir}/${i}
done

if [ -h ${DB_ROOT_DIR}/tubes ]; then
	olddir=$( readlink ${DB_ROOT_DIR}/tubes )
	echo "remove old dir: ${olddir}, new lnk - ${tmpdir}"
	echo "ln -sf ${tmpdir} ${DB_ROOT_DIR}/tubes"
	rm -f ${DB_ROOT_DIR}/tubes && ln -s ${tmpdirname} ${DB_ROOT_DIR}/tubes
	rm -rf ${olddir}
else
	ln -s ${tmpdirname} ${DB_ROOT_DIR}/tubes
fi

/root/bin/patrol.sh
