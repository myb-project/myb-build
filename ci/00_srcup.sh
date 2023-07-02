#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e
cbsd srcup ver=${mybbasever} rev=2b5dd8b8901
exit 0
