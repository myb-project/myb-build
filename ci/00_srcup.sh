#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e
#cbsd srcup ver=${mybbasever} rev=2b5dd8b8901
cbsd srcup ver=${mybbasever}
exit 0
