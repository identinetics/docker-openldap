#!/bin/sh
##
# Initialize the LDAP
#
# TODO: $ROOTPW > ldif
#
# TODO: Exit with failure on test errors (best way for jenkins?)
#

ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/olcrootpw.ldif
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /etc/openldap/schema/inetorgperson.ldif

# configure the mdb
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/phoat_config.ldif

# frontend access restriction
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/restrict_frontend.ldif


# our additional schemas
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f  /opt/init/openldap/schemas/phonlineperson.ldif
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/schemas/idnsyncstat.ldif

# indexes
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/phoat_indexes.ldif


# init compare overlay
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/twcompare_module.ldif
ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/phoat_twcompare_config.ldif

# manager access
/opt/init/openldap/scripts/root2me.sh /opt/init/openldap/ldifs/phoat_manager.ldif
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/phoat_manager.ldif

# PH Structure
ldapadd -h $SLAPDHOST -p $SLAPDPORT \
     -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
     -c -f /opt/sample_data/etc/openldap/data/phoAt_init.ldif

# bmb read access
ldapadd -h $SLAPDHOST -p $SLAPDPORT \
     -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
     -c -f /opt/init/openldap/ldifs/bmbreader.ldif


# patch 0

ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p0.access.ldif
ldapadd -h $SLAPDHOST -p $SLAPDPORT -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -f  /opt/init/openldap/ldifs/p0.monitoring.0.ldif
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p0.monitoring.1.ldif

# patch 1

ldapadd -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p1.patchlevel.0.ldif
ldapmodify -h $SLAPDHOST -p $SLAPDPORT -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -f  /opt/init/openldap/ldifs/p1.patchlevel.1.ldif
ldapmodify -h $SLAPDHOST -p $SLAPDPORT -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -f  /opt/init/openldap/ldifs/p1.patchlevel.2.ldif

# patch 2

ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p2.idndeleted.0.ldif
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p2.idndeleted.1.ldif
ldapmodify -h $SLAPDHOST -p $SLAPDPORT -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
   -f  /opt/init/openldap/ldifs/p2.patchlevel.2.ldif

# patch 3

ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -f /opt/init/openldap/ldifs/p3.sha512.0.ldif
ldapmodify -h $SLAPDHOST -p $SLAPDPORT -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
  -f /opt/init/openldap/ldifs/p3.patchlevel.1.ldif

##
## after init is done, do some general tests:
##

ldapadd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_test.ldif

ldappasswd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -s 'test' \
    'cn=test.user1234567, ou=user, ou=ph08, o=BMUKK'

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -b "ou=ph08, o=BMUKK" -LLL 'cn=*'

## now some overlay tests

# returns 1

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -b "ou=ph08, o=BMUKK" -LLL 'cn=*' 'idnSyncDiff'

# set an etdTimestamp < etlTimestamp

ldapmodify -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -c << EOF
dn: cn=test.user1234567,ou=user,ou=ph08,o=BMUKK
changetype: modify
replace: etdTimestamp
etdTimestamp: 20160101000000Z
EOF

# still 1

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -b "ou=ph08, o=BMUKK" -LLL 'cn=*' 'idnSyncDiff'

# set an etdTimestamp == etlTimestamp

ldapmodify -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -c << EOF
dn: cn=test.user1234567,ou=user,ou=ph08,o=BMUKK
changetype: modify
replace: etdTimestamp
etdTimestamp: 20170724132659Z
EOF

# now 0

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -b "ou=ph08, o=BMUKK" -LLL 'cn=*' 'idnSyncDiff'


# set an etlTimestamp < etdTimestamp

ldapmodify -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -c << EOF
dn: cn=test.user1234567,ou=user,ou=ph08,o=BMUKK
changetype: modify
replace: etlTimestamp
etlTimestamp: 20170724132658Z
EOF

# now -1

ldapsearch -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    -b "ou=ph08, o=BMUKK" -LLL 'cn=*' 'idnSyncDiff'

# removing our test user

ldapdelete -h $SLAPDHOST -p $SLAPDPORT \
    -x -D "cn=admin,o=BMUKK" -w $ROOTPW \
    'cn=test.user1234567, ou=user, ou=ph08, o=BMUKK'
