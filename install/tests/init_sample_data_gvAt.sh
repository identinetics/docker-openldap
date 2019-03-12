#!/bin/sh

echo "loading /etc/openldap with sample data "

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapadd -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -f /opt/sample_data/etc/openldap/data/gvAt_init.ldif

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -s 'test' 'gvGid=AT:B:1:12346,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -s 'test' 'gvGid=AT:B:1:12347,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -s 'test' 'gvGid=AT:B:1:12348,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -s 'test' 'gvGid=AT:B:1:12349,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at'