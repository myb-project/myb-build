#!/bin/sh
mybbasever="13.2"

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

dstdir=$( mktemp -d )

# cleanup old pkg ?
#/var/cache/packages/pkgdir-cpr3e421 (host) -> /tmp/packages (jail)

echo "cbsd cpr pkglist=/root/myb-build/micro.list dstdir=${dstdir}"
cbsd cpr pkglist=/root/myb-build/micro.list dstdir=${dstdir}

[ -d ${progdir}/micro1 ] && rm -rf ${progdir}/micro1
mkdir -p ${progdir}/micro1

[ ! -d ${progdir}/micro1/usr/local/bin ] && mkdir -p ${progdir}/micro1/usr/local/bin
[ ! -d ${progdir}/micro1/etc ] && mkdir -p ${progdir}/micro1/etc
[ ! -d ${progdir}/usr/local/share ] && mkdir -p ${progdir}/micro1/usr/local/share

for i in kubectl helm k9s; do
	if [ ! -x /usr/jails/jails-data/cpr3e421-data/usr/local/bin/${i} ]; then
		echo "no such: /usr/jails/jails-data/cpr3e421-data/usr/local/bin/${i}"
		exit 1
	else
		echo "copy ${i} -> ${progdir}/micro1/usr/local/bin"
		cp -a /usr/jails/jails-data/cpr3e421-data/usr/local/bin/${i} ${progdir}/micro1/usr/local/bin
	fi
done

# CA
if [ ! -r /usr/jails/jails-data/cpr3e421-data/usr/local/share/certs/ca-root-nss.crt ]; then
	echo "no such: /usr/jails/jails-data/cpr3e421-data/usr/local/share/certs/ca-root-nss.crt from ca_root_nss"
	exit 1
fi

echo "copy /etc/ssl -> ${progdir}/micro1/etc/"
echo "copy /usr/local/share/certs -> ${progdir}/micro1/usr/local/share/"
cp -a /usr/jails/jails-data/cpr3e421-data/etc/ssl ${progdir}/micro1/etc/
cp -a /usr/jails/jails-data/cpr3e421-data/usr/local/share/certs ${progdir}/micro1/usr/local/share/

exit 0
