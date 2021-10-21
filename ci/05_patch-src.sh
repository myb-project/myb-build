#!/bin/sh

set +e

cbsd srcup ver=13.0

SRC_ROOT="/usr/jails/src/src_13.0/src"

if [ ! -r ${SRC_ROOT}/Makefile ]; then
	echo "no such src: ${SRC_ROOT}"
	exit 1
fi

cd ${SRC_ROOT}/usr.sbin/bsdinstall/distextract
PATCH="/root/myb-build/patch/13x/patch-usr-sbin-bsdinstall-distextract-distextract.c"
patch --check -N < ${PATCH} > /dev/null 2>&1
[ $? -eq 0 ] && echo "apply ${PATCH}.." && patch < ${PATCH}
find ${SRC_ROOT}/usr.sbin/bsdinstall/distextract -type f -name \*.orig -delete

cd ${SRC_ROOT}/usr.sbin/bsdinstall/distfetch
PATCH="/root/myb-build/patch/13x/patch-usr-sbin-bsdinstall-distfetch-distfetch.c"
patch --check -N < ${PATCH} > /dev/null 2>&1
[ $? -eq 0 ] && echo "apply ${PATCH}.." && patch < ${PATCH}
find ${SRC_ROOT}/usr.sbin/bsdinstall/distfetch -type f -name \*.orig -delete


cd ${SRC_ROOT}/usr.sbin/bsdinstall/scripts
for i in adduser checksum docsinstall hardening hostname jail keymap mirrorselect mount netconfig netconfig_ipv4 netconfig_ipv6 rootpass services wlanconfig zfsboot bootconfig; do
	PATCH="/root/myb-build/patch/13x/patch-usr-sbin-bsdinstall-scripts-${i}"
	patch --check -N < ${PATCH} > /dev/null 2>&1
	[ $? -eq 0 ] && echo "apply ${PATCH}.." && patch < ${PATCH}
done
find ${SRC_ROOT}/usr.sbin/bsdinstall/scripts -type f -name \*.orig -delete

cp -a /root/myb-build/patch/13x/auto ${SRC_ROOT}/usr.sbin/bsdinstall/scripts/auto
