#!/bin/sh
mybbasever="13.2"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

dstdir=$( mktemp -d )

# cleanup old pkg ?
#/var/cache/packages/pkgdir-cpr9ca75 (host) -> /tmp/packages (jail)

echo "cbsd cpr pkglist=/root/myb-build/myb.list dstdir=${dstdir}"

PREFETCHED_PACKAGES="\
gcc12 \
nginx \
cdrkit \
python39 \
py39-certbot \
mutt \
kubectl \
php82 \
libvncserver \
gnutls \
sqlite3 \
bash \
npm-node18 \
node \
sudo \
git \
pkgconf \
py39-numpy \
php82-session \
go120 \
rsync \
beanstalkd \
tmux \
hw-probe \
jq \
cmake \
ninja"

cbsd cpr makeconf=/root/myb-build/myb_make.conf pkglist=/root/myb-build/myb.list dstdir=${dstdir} package_fetch="${PREFETCHED_PACKAGES}" autoremove=1

cbsd jstart jname=cpr9ca75 || true

cp -a ${progdir}/scripts/cix_upgrade /usr/jails/jails-data/cpr9ca75-data/root/
cbsd jexec jname=cpr9ca75 /root/cix_upgrade
cp -a /usr/jails/jails-data/cpr9ca75-data/tmp/myb_ver.conf ${progdir}/cbsd/
cp -a /usr/jails/jails-data/cpr9ca75-data/tmp/myb_ver.json ${progdir}/cbsd/

cbsd jstop jname=cpr9ca75 || true

mv ${dstdir}/* ${progdir}/cbsd/

rm -rf ${dstdir}

[ ! -h ${progdir}/cbsd/pkg.pkg ] && exit 1

exit 0
