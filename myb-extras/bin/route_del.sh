#!/bin/sh

. /etc/rc.conf

[ "${myb_net_cur_profile}" != "2" ] && exit 0
[ -z "${ipv6_first}" ] && exit 0

echo "delete route for profile 2"
/sbin/route -6 delete ${ipv6_first} -interface bridge200

exit 0
