#!/bin/sh

set -o errexit

# refresh modules
[ -d /root/myb-build/myb-extras/myb.d ] && rm -rf /root/myb-build/myb-extras/myb.d
cp -a /usr/local/cbsd/modules/myb.d /root/myb-build/myb-extras/
rm -rf /usr/local/cbsd/modules/myb.d/.git || true

#/root/myb-build/ci/00_srcup.sh
#/root/myb-build/ci/10_patch-src.sh
#/root/myb-build/ci/20_world.sh
#/root/myb-build/ci/30_cpr.sh
/root/myb-build/ci/40_jail.sh
/root/myb-build/ci/50_purgejail.sh
/root/myb-build/ci/60_distribution.sh
/root/myb-build/ci/70_manifests.sh
/root/myb-build/ci/90_conv.sh

echo
echo "scp /tmp/mybee1-13.1_amd64.img oleg@172.16.0.3:mybee1-13.1_amd64.img"
echo
