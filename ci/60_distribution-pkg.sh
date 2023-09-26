#!/bin/sh
set +e
. /etc/rc.conf          # mybbasever
jname="mybee1"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

: ${distdir="/usr/local/cbsd"}
[ ! -r "${distdir}/subr/cbsdbootstrap.subr" ] && exit 1
. ${distdir}/subr/cbsdbootstrap.subr || exit 1

mount -t devfs devfs /tmp/mybase/dev

[ ! -d /tmp/mybase/usr/local/etc/pkg/repos ] && mkdir -p /tmp/mybase/usr/local/etc/pkg/repos
cp -a ${progdir}/myb-extras/pkg/Mybee-latest.conf /tmp/mybase/usr/local/etc/pkg/repos/

chroot /tmp/mybase /bin/sh <<EOF
pkg update -f
pkg install -y myb nginx cbsd cbsd-mq-router cbsd-mq-api curl jq cdrkit-genisoimage ca_root_nss beanstalkd bash dmidecode hw-probe rsync smartmontools sudo tmux mc
EOF

# extra check
umount -f /tmp/mybase/dev

CHECK_FILES="/tmp/mybase/usr/local/bin/tmux \
/tmp/mybase/usr/local/bin/mc \
/tmp/mybase/usr/local/bin/curl \
/tmp/mybase/usr/local/myb/mybinst.sh \
/tmp/mybase/usr/local/sbin/nginx \
/tmp/mybase/usr/local/bin/cbsd \
/tmp/mybase/usr/local/bin/cbsd-mq-api \
/tmp/mybase/usr/local/bin/cbsd-mq-router"


failed=0
for i in ${CHECK_FILES}; do
	if [ ! -x ${i} ]; then
	echo "pkg install failed: no such ${i}"
	exit 1
	fi
done

cbsd mkdistribution ver=${mybbasever} distribution="base" sourcedir=/tmp/mybase destdir="${workdir}/jails-data/${jname}-data/usr/freebsd-dist"
ret=$?
if [ ${ret} -ne 0 ]; then
	echo "cbsd mkdistribution failed"
	exit ${ret}
fi

exit 0
