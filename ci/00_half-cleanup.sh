#!/bin/sh
# Remove !^FreeBSD packages only
pgm="${0##*/}"                          # Program basename
progdir="${0%/*}"                       # Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

. /etc/rc.conf          # mybbasever
set +e

if [ -z "${mybbasever}" ]; then
	echo "Please specify mybbasever= via /etc/rc.conf, e.g: sysrc -q mybbasever=\"14.0\""
	exit 1
fi

ver=${mybbasever%%.*}

if [ ! -h ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest ]; then
	echo "no such ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest symlink to repo"
	exit 1
fi

# -regex ^FreeBSD\* -not  ^(?!FreeBSD).*$
find ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/ \( -type l -or -type f \) -and \( -perm +111 \) -depth 1 -maxdepth 1 -exec basename {} \; | while read _f; do
	case "${_f}" in
		FreeBSD*)
			continue
			;;
		*)
			rm -f ${progdir}/cbsd/FreeBSD:${ver}:amd64/latest/${_f}
			;;
	esac
done

exit 0
