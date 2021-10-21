#!/bin/sh

rm -rf /usr/jails/jails-data/jail1-data/rescue
rm -rf /usr/jails/jails-data/jail1-data/tmp/*
rm -rf /usr/jails/jails-data/jail1-data/usr/include
rm -rf /usr/jails/jails-data/jail1-data/usr/lib/clang
rm -rf /usr/jails/jails-data/jail1-data/usr/lib/dtrace
rm -f /usr/jails/jails-data/jail1-data/usr/lib/*.a
rm -f /usr/jails/jails-data/jail1-data/usr/lib/*.o
rm -rf /usr/jails/jails-data/jail1-data/usr/lib32

rm -rf /usr/jails/jails-data/jail1-data/usr/share/calendar
rm -rf /usr/jails/jails-data/jail1-data/usr/share/dict
rm -rf /usr/jails/jails-data/jail1-data/usr/share/doc
rm -rf /usr/jails/jails-data/jail1-data/usr/share/dtrace
rm -rf /usr/jails/jails-data/jail1-data/usr/share/examples
rm -rf /usr/jails/jails-data/jail1-data/usr/share/games
rm -rf /usr/jails/jails-data/jail1-data/usr/share/i18n
rm -rf /usr/jails/jails-data/jail1-data/usr/share/kyua

rm -rf /usr/jails/jails-data/jail1-data/usr/share/locale/*
rm -rf /usr/jails/jails-data/jail1-data/usr/share/man
rm -rf /usr/jails/jails-data/jail1-data/usr/share/openssl
rm -rf /usr/jails/jails-data/jail1-data/usr/share/sendmail
rm -rf /usr/jails/jails-data/jail1-data/usr/share/snmp

mkdir /usr/jails/jails-data/jail1-data/usr/freebsd-dist

sysrc -qf /usr/jails/jails-data/jail1-data/etc/rc.conf \
sendmail_enable="NO" \
sendmail_submit_enable="NO" \
sendmail_outbound_enable="NO" \
sendmail_msp_queue_enable="NO" \
syslogd_flags="-ss"

# cron disable
