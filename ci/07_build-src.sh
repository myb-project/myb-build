#!/bin/sh

set +e

cbsd world ver=13.0 && cbsd kernel ver=13.0
[ -d /usr/jails/basejail/base_amd64_amd64_13.0/rescue ] && rm -rf /usr/jails/basejail/base_amd64_amd64_13.0/rescue
