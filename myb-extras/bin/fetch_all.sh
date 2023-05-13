#!/bin/sh

echo "[Fetch all cloud images]"
DIR="/root/bin"

[ ! -d ${DIR} ] && exit 1

cd ${DIR}

A=$( find ${DIR}/ -type f -perm +111 -exec basename {} \; | sort )

for i in ${A}; do
	p1=${i%%\.*}
	p2=${i##*\.}
	# skip for .sh
	[ "${p2}" = "sh" ] && continue
	[ "${i}" = "web_upgrade" ] && continue
	echo $i
	${DIR}/${i}
done

exit 0
