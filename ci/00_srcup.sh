#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e

echo "Build MyBee base version: ${mybbasever}"
cbsd srcup ver=${mybbasever} rev=8d60ede293e

exit 0
