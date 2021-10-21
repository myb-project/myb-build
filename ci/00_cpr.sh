#!/bin/sh
[ -d /tmp/y ] && rm -rf /tmp/y
cbsd cpr pkglist=/root/myb-build/myb.list dstdir=/tmp/y

[ -d /root/myb-build/cbsd ] && rm -rf /root/myb-build/cbsd
mkdir -p /root/myb-build/cbsd

mv /tmp/y/* /root/myb-build/cbsd/
