#!/bin/sh

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
source $SCRIPTDIR/set_conf.sh

ldapadd -h $SLAPDHOST -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_test.ldif

ldappasswd -h $SLAPDHOST -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW \
    -s $TESTUSERPW $TESTUSERDN
