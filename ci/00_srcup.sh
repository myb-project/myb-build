#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e
cbsd srcup ver=${mybbasever}
exit 0
