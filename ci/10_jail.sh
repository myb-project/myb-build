#!/bin/sh

cbsd jremove jail1 || true
cbsd jcreate jname=jail1 baserw=1 runasap=1 astart=0
cbsd jstop jname=jail1
