#!/bin/sh

# ${myb_version}
if [ -r /usr/local/etc/mybee/version ]; then
	. /usr/local/etc/mybee/version
fi

[ -z "${myb_version}" ] && myb_version="unknown"

# track ip changes and reflect it in config files (e.g. dynamic/manual/DHCP changes)
uplink_iface4=$( /sbin/route -n -4 get 0.0.0.0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )
ip4_addr=$( /sbin/ifconfig ${uplink_iface4} | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )

uplink_iface6=$( /sbin/route -n -6 get ::0 2>/dev/null | /usr/bin/awk '/interface/{print $2}' )

if [ -n "${uplink_iface6}" ]; then
	ip6=$( /sbin/ifconfig ${uplink_iface6} | /usr/bin/awk '/inet6 *:*+/{print $2}' | /usr/bin/grep -v %${uplink_iface6}$ | /usr/bin/head -n1 )
else
	# route can not work in jail, looks at all
	ip6=$( /sbin/ifconfig | /usr/bin/awk '/inet6 *:*+/{print $2}' | /usr/bin/grep -v %${uplink_iface6}$ | /usr/bin/head -n1 )
fi

if [ -n "${uplink_iface4}" ]; then
	ip4=$( /sbin/ifconfig ${uplink_iface4} | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )
else
	# route can not work in jail, looks at all
	ip4=$( /sbin/ifconfig | /usr/bin/awk '/inet [0-9]+/{print $2}'| /usr/bin/head -n1 )
fi


#echo "up $uplink_iface4"
#echo "up $uplink_iface6"

[ ! -d  /var/db/mybee ] && mkdir -p /var/db/mybee
if [ -r /var/db/mybee/auto_ip.conf ]; then
	. /var/db/mybee/auto_ip.conf
else
	old_v4=
	old_v6=
fi

if [ "${old_v4}" = "${ip4}" -a "${old_v6}" = "ip6}" ]; then
	echo "[${ip4}/${ip6}] unchanged"
	exit 0
fi

echo "ip changed"
echo "-- ${old_v4}"
echo "-- ${old_v6}"
echo "++ ${ip4}"
echo "++ ${ip6}"

# triggering/refresh services/config

# API SERVICES
# defaults
# for API services
schema="http"
sed -e "s:%%IP%%:${ip4}:g" \
	-e "s:%%SCHEMA%%:${schema}:g" \
	/usr/local/etc/mybee/cbsd-mq-api.json > /tmp/cbsd-mq-api.json.$$

if [ ! -r /usr/local/etc/cbsd-mq-api.json ]; then
	echo "install new api config"
	mv /tmp/cbsd-mq-api.json.$$ /usr/local/etc/cbsd-mq-api.json
	service cbsd-mq-api restart > /dev/null 2>&1
else
	diff=$( diff -ruN /usr/local/etc/cbsd-mq-api.json /tmp/cbsd-mq-api.json.$$ )
	if [ -n "${diff}" ]; then
		echo "install new api config"
		mv /tmp/cbsd-mq-api.json.$$ /usr/local/etc/cbsd-mq-api.json
		service cbsd-mq-api restart > /dev/null 2>&1
	else
		rm -f /tmp/cbsd-mq-api.json.$$
	fi
fi

# PUBLIC_HTML
sed -e "s:%%IP%%:${ip4}:g" \
	-e "s:%%SCHEMA%%:${schema}:g" \
	/usr/local/etc/mybee/index.html.tpl > /tmp/index.html.$$

[ ! -d /usr/local/www/public ] && mkdir -p /usr/local/www/public
if [ ! -r /usr/local/www/public/index.html ]; then
	echo "install new html page"
	mv /tmp/index.html.$$ /usr/local/www/public/index.html
else
	diff=$( diff -ruN /usr/local/www/public/index.html /tmp/index.html.$$ )
	if [ -n "${diff}" ]; then
		echo "install new html page"
		mv /tmp/index.html.$$ /usr/local/www/public/index.html
	else
		rm -f /tmp/index.html.$$
	fi
fi


# /ETC/ISSUE
cat > /tmp/issue.$$ <<EOF

 === Welcome to MyBee ${myb_version} ===
 * API: ${schema}://${ip4}
 * SSH: ${ip4}

EOF

if [ ! -r /etc/issue ]; then
	echo "install new issue banner"
	mv /tmp/issue.$$ /etc/issue
else
	diff=$( diff -ruN /etc/issue /tmp/issue.$$ )
	if [ -n "${diff}" ]; then
		echo "install new issue banner"
		mv /tmp/issue.$$ /etc/issue
	else
		rm -f /tmp/issue.$$
	fi
fi
