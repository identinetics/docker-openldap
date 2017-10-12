#!/usr/bin/env bash

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
source $SCRIPTDIR/set_conf.sh

ldapsearch -h localhost -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW -b $BASEDN -LLL "cn=$TESTUSERCN"

# sample commands
# ldapsearch -h localhost -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW -b $BASEDN -LLL 'uid=test.user'
# ldapmodify -h localhost -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW -c -f /tmp/x.ldif
# ldapdelete -h localhost -p $SLAPDPORT -x -D $ROOTDN -w $ROOTPW $TESTUSERDN
