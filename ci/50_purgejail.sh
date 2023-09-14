#!/bin/sh

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

# not necessary
rm -rf ${workdir}/jails-data/${jname}-data/sbin/init.bak
rm -rf ${workdir}/jails-data/${jname}-data/sbin/pfctl
rm -rf ${workdir}/jails-data/${jname}-data/sbin/ipf
rm -rf ${workdir}/jails-data/${jname}-data/sbin/hastd
rm -rf ${workdir}/jails-data/${jname}-data/sbin/dnctl
rm -rf ${workdir}/jails-data/${jname}-data/sbin/ipfw
rm -rf ${workdir}/jails-data/${jname}-data/lib/libdtrace*
rm -rf ${workdir}/jails-data/${jname}-data/boot/loader_lua.efi
rm -rf ${workdir}/jails-data/${jname}-data/bin/tcsh
rm -rf ${workdir}/jails-data/${jname}-data/var/db/pkg/*
rm -rf ${workdir}/jails-data/${jname}-data/libexec/ld-elf32*
rm -rf ${workdir}/jails-data/${jname}-data/usr/local/man/*

#??
rm -rf ${workdir}/jails-data/${jname}-data/usr/local/sbin/pkg-static*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/a*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/el*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/b*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/c*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/d*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/f*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/g*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/h*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/i*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/j*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/l*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/m*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/n*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/r*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/k*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/p*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/s*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/z*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/t*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/nls/u*

rm -rf ${workdir}/jails-data/${jname}-data/usr/share/mk
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/misc/magic.mgc
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/bhyve

rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/sendmail

rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/atf-check
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/atf-sh
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/atf_pytest_wrapper
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/atrun
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/blacklistd-helper
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/bootpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/bootpgw
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/dma
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/dma-mbox-create
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/dwatch
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/fingerd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/flua
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ftpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/fwget
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/hyperv
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ipropd-master
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ipropd-slave
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kadmind
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kcm
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kdc
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kdigest
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kfd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kimpersonate
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/kpasswdd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/locate.bigram
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/locate.code
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/locate.concatdb
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/locate.mklocatedb
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/locate.updatedb
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/lpr
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/mail.local
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/makewhatis.local
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ntalkd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/pppoed
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rbootd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/revnetgroup
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rpc.rquotad
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rpc.rstatd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rpc.rusersd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rpc.rwalld
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/rpc.sprayd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/sftp-server
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/sm.bin
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/smrsh
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ssh-keysign
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ssh-pkcs11-helper
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ssh-sk-helper
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/tcpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/tftp-proxy
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/tftpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ulog-helper
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/yppwupdate
rm -rf ${workdir}/jails-data/${jname}-data/usr/libexec/ypxfr

#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/acpidb
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/acpidump
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/cxgbetool
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/auditdistd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/authpf
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/authpf-noip
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/automount
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/automountd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/autounmountd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bhyve
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bhyvectl
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/blacklistd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bootpef
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bsnmpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bthidcontrol
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/bthidd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/camdd
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/config
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/cron
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ctladm
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ctld
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/cxgbetool
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/dtrace
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/editmap
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/etcupdate
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/freebsd-update
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ftp-proxy
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/hccontrol
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/hostapd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/hostapd_cli
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/iasl
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/inetd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/iscsid
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/jail
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/kbdcontrol
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ktutil
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/local-unbound
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/local-unbound-anchor
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/lockstat
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/lpc
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/lpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mailstats
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/makefs
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/makemap
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mergemaster
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mfiutil
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mountd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/moused
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mprutil
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mpsutil
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mptutil
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mrsasutil
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/mtree
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ndp
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/newsyslog
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/nmtree
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/nologin
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/nscd
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ntp-keygen
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ntpd
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ntpdate
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ntpdc
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ntptime
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/pciconf
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/pmc
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/pmcstat
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ppp
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/praliases
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/pw
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/route6d
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/rpc.lockd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/rpc.yppasswdd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/rpcbind
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/rtadvd
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/rtsold
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/sdpd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/sntp
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/sshd
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/syslogd
#rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/tcpdump
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/wpa_cli
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/wpa_passphrase
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/wpa_supplicant
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ypldap
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/ypserv
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/zdb
rm -rf ${workdir}/jails-data/${jname}-data/usr/sbin/zfsd

rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/libpmc*
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/libprivateunbound*


rm -rf ${workdir}/jails-data/${jname}-data/usr/tests
rm -rf ${workdir}/jails-data/${jname}-data/rescue
rm -rf ${workdir}/jails-data/${jname}-data/tmp/*
rm -rf ${workdir}/jails-data/${jname}-data/usr/include
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/clang
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib/dtrace
rm -f ${workdir}/jails-data/${jname}-data/usr/lib/*.a
rm -f ${workdir}/jails-data/${jname}-data/usr/lib/*.o
rm -rf ${workdir}/jails-data/${jname}-data/usr/lib32

rm -rf ${workdir}/jails-data/${jname}-data/usr/share/calendar
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/dict
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/doc
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/dtrace
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/examples
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/games
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/i18n
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/kyua

rm -rf ${workdir}/jails-data/${jname}-data/usr/share/locale/*
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/man
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/openssl
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/sendmail
rm -rf ${workdir}/jails-data/${jname}-data/usr/share/snmp

for i in c++ \
cc \
clang \
clang++ \
clang-cpp \
cpp \
gcov \
kyua \
ld.lld \
lldb \
lldb-server \
llvm-addr2line \
llvm-ar \
llvm-cov \
llvm-nm \
llvm-objcopy \
llvm-objdump \
llvm-profdata \
llvm-ranlib \
llvm-readelf \
llvm-readobj \
llvm-size \
llvm-strip \
llvm-symbolizer \
objdump; do
	rm -f ${workdir}/jails-data/${jname}-data/usr/bin/$i
done
[ ! -f ${workdir}/jails-data/${jname}-data/usr/freebsd-dist ] && mkdir ${workdir}/jails-data/${jname}-data/usr/freebsd-dist

sysrc -qf ${workdir}/jails-data/${jname}-data/etc/rc.conf \
	sendmail_enable="NO" \
	sendmail_submit_enable="NO" \
	sendmail_outbound_enable="NO" \
	sendmail_msp_queue_enable="NO" \
	syslogd_flags="-ss" \
	moused_nondefault_enable="NO"

# cron disable
