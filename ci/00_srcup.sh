#!/bin/sh
. /etc/rc.conf		# mybbasever
set +e
cbsd srcup ver=${mybbasever} rev=4e027ca1514
#cbsd srcup ver=${mybbasever}
exit 0
