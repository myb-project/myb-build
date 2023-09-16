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

SRC_ROOT="${srcdir}/src_${mybbasever}/src"

if [ ! -r ${SRC_ROOT}/Makefile ]; then
	echo "no such src: ${SRC_ROOT}"
	exit 1
fi

if [ -d /tmp/mybase ]; then
	umount -f /tmp/mybase/dev > /dev/null 2>&1 || true
	chflags -R noschg /tmp/mybase
	rm -rf /tmp/mybase
fi

cbsd install-pkg-world destdir=/tmp/mybase ver=14.0 cmd_helper=1 packages="FreeBSD-runtime FreeBSD-utilities FreeBSD-ssh FreeBSD-vi FreeBSD-csh FreeBSD-clibs FreeBSD-fetch FreeBSD-libarchive FreeBSD-libbz2 FreeBSD-liblzma FreeBSD-libucl FreeBSD-openssl FreeBSD-zoneinfo FreeBSD-libexecinfo FreeBSD-kernel-cbsd FreeBSD-bootloader FreeBSD-devd FreeBSD-newsyslog FreeBSD-pf FreeBSD-ipfw FreeBSD-geom FreeBSD-syslogd FreeBSD-bhyve FreeBSD-acpi FreeBSD-devmatch FreeBSD-dhclient"

# for base-in-packages
#cbsd  mkdistribution ver=${mybbasever} distribution="base kernel" srcdir=/tmp/mybase destdir="${workdir}/jails-data/${jname}-data/usr/freebsd-dist"

mount -t devfs devfs /tmp/mybase/dev

[ ! -d /tmp/mybase/usr/local/etc/pkg/repos ] && mkdir -p /tmp/mybase/usr/local/etc/pkg/repos
cp -a ${progdir}/myb-extras/pkg/Mybee-latest.conf /tmp/mybase/usr/local/etc/pkg/repos/

chroot /tmp/mybase /bin/sh <<EOF
pkg update -f
pkg install -y myb nginx cbsd cbsd-mq-router cbsd-mq-api curl jq cdrkit-genisoimage ca_root_nss beanstalkd bash dmidecode hw-probe rsync smartmontools sudo tmux mc
EOF

# extra via menu
#kubectl mutt py39-certbot

umount -f /tmp/mybase/dev

cbsd mkdistribution ver=${mybbasever} distribution="base" srcdir=/tmp/mybase destdir="${workdir}/jails-data/${jname}-data/usr/freebsd-dist"

#rm -rf /tmp/mybase/boot
#cp -a /boot /tmp/mybase/
#rm -rf /tmp/mybase/boot/kernel /tmp/mybase/boot/kernel.old

# for legacy:
#cbsd  mkdistribution ver=${mybbasever} distribution="base kernel" destdir="${workdir}/jails-data/${jname}-data/usr/freebsd-dist"
#mv ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/kernel-GENERIC.txz ${workdir}/jails-data/${jname}-data/usr/freebsd-dist/kernel.txz
