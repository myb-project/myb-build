#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e

echo "Build MyBee base version: ${mybbasever}"
cbsd srcup ver=${mybbasever} rev=243550d32f4

src_dir_makefile="/usr/jails/src/src_${mybbasever}/src/Makefile"

if [ ! -r ${src_dir_makefile} ]; then
	echo "no such source: ${src_dir_makefile}"
	exit 1
fi

exit 0
