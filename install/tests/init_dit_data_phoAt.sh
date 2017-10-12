#!/bin/sh

echo "loading /etc/openldap with initial tree data "

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
source $SCRIPTDIR/set_conf.sh

ldapadd -h $SLAPDHOST -p $SLAPDPORT -x -D $rootdn -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_init.ldif
