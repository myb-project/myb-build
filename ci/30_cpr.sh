#!/bin/sh
. /etc/rc.conf          # mybbasever
pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

dstdir=$( mktemp -d )

cpr_jname="cpr9ca75"

# cleanup old pkg ?
#/var/cache/packages/pkgdir-${cpr_jname} (host) -> /tmp/packages (jail)

ver=${mybbasever%%.*}

if [ ! -h ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest ]; then
	echo "no such ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest symlink to repo"
	exit 1
fi

cbsd jstatus jname=${cpr_jname} || cbsd jremove jname=${cpr_jname}

echo "cbsd cpr ver=${mybbasever} pkglist=/root/myb-build/myb.list dstdir=${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/"

PREFETCHED_PACKAGES="\
nginx \
cdrkit \
python39 \
py39-certbot \
mutt \
kubectl \
gnutls \
sqlite3 \
bash \
sudo \
pkgconf \
go120 \
rsync \
beanstalkd \
tmux \
hw-probe \
jq \
cmake \
ninja \
ca_root_nss \
beanstalkd \
nginx \
tmux \
mutt \
kubectl \
hw-probe \
jq \
mc \
gmake \
"
# MC needs for 'mcedit' !!
#/usr/ports/net/realtek-re-kmod


cbsd cpr makeconf=/root/myb-build/myb_make.conf ver=${mybbasever} pkglist=/root/myb-build/myb.list dstdir=${dstdir} package_fetch="${PREFETCHED_PACKAGES}" autoremove=1

cbsd jstart jname=${cpr_jname} || true

cp -a ${progdir}/scripts/cix_upgrade /usr/jails/jails-data/${cpr_jname}-data/root/
cbsd jexec jname=${cpr_jname} /root/cix_upgrade

# original?
cp -a /usr/jails/jails-data/${cpr_jname}-data/tmp/myb_ver.conf ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/
cp -a /usr/jails/jails-data/${cpr_jname}-data/tmp/myb_ver.json ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/

cbsd jstop jname=${cpr_jname} || true

mv ${dstdir}/* ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/

rm -rf ${dstdir}
[ ! -h ${progdir}/cbsd/pkg.pkg ] && exit 1

cbsd jremove jname=${cpr_jname} > /dev/null 2>&1

exit 0
