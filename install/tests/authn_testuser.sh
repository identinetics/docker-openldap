#!/usr/bin/env bash

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
source $SCRIPTDIR/set_conf.sh

ldapsearch -h localhost -p $SLAPDPORT -x -D $TESTUSERDN -w $TESTUSERPW -b $BASEDN -LLL 'objectclass=*'
