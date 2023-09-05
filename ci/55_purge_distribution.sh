#!/bin/sh
set +e

pgm="${0##*/}"				# Program basename
progdir="${0%/*}"			# Program directory
progdir=$( realpath ${progdir} )
progdir=$( dirname ${progdir} )

# golang
echo "$pgm"

cd ${progdir}/cbsd/
find . -type f -regex "./go[0-9].*.pkg" -delete

find . -type f -regex "./cmake.*.pkg" -delete
find . -type f -regex "./gmake.*.pkg" -delete
find . -type f -regex "./ninja.*.pkg" -delete
find . -type f -regex "./c-ares.*.pkg" -delete

# autoremove
find . -type f -regex "./binutils.*.pkg" -delete
find . -type f -regex "./brotli.*.pkg" -delete
find . -type f -regex "./icu.*.pkg" -delete
find . -type f -regex "./jsoncpp.*.pkg" -delete
find . -type f -regex "./libargon2.*.pkg" -delete
find . -type f -regex "./libuv.*.pkg" -delete
find . -type f -regex "./metis.*.pkg" -delete
find . -type f -regex "./mpc.*.pkg" -delete
find . -type f -regex "./mpfr.*.pkg" -delete
find . -type f -regex "./rhash.*.pkg" -delete



#find . -type f -regex "        gcc12: 12.2.0_6
#        openblas: 0.3.20_1,1
#        py39-numpy: 1.24.1_4,1
#        suitesparse-amd: 3.0.3_1
#        suitesparse-camd: 3.0.3_1
#        suitesparse-ccolamd: 3.0.3_1
#        suitesparse-cholmod: 4.0.3_1
#        suitesparse-colamd: 3.0.3_1
#        suitesparse-config: 7.0.1_1
#        suitesparse-umfpack: 6.1.0_1

# php
