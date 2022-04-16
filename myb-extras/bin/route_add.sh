#!/bin/sh

. /etc/rc.conf

[ "${myb_net_cur_profile}" != "2" ] && exit 0
[ -z "${ipv6_first}" ] && exit 0

echo "setup route for profile 2"
/sbin/route -6 add ${ipv6_first} -interface bridge200

/usr/sbin/daemon -f /sbin/ping -6 -c 10 ${ipv6_first}

exit 0
