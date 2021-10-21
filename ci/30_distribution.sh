#!/bin/sh

set +e

cbsd mkdistribution distribution="base kernel" destdir="/usr/jails/jails-data/jail1-data/usr/freebsd-dist"
mv /usr/jails/jails-data/jail1-data/usr/freebsd-dist/kernel-GENERIC.txz /usr/jails/jails-data/jail1-data/usr/freebsd-dist/kernel.txz
