#!/usr/bin/env bash

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
source $SCRIPTDIR/set_conf.sh

ldapadd -h localhost -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW -c -f /opt/sample_data/etc/openldap/data/phoAt_test.ldif

$PY3 /tests/test1.py -D $ROOTDN -w $ROOTPW -b $BASEDN

