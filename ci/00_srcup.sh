#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e

if [ -z "${mybbasever}" ]; then
	echo "Please specify mybbasever= via /etc/rc.conf, e.g: sysrc -q mybbasever=\"14.0\""
	exit 1
fi

echo "Build MyBee base version: ${mybbasever}"
cbsd srcup ver=${mybbasever} rev=4e027ca1514

exit 0
