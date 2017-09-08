#!/usr/bin/env bash

#
# starting slapd for the new, dynamic configuration
#
#
# .. but first make sure the ldap user has admin rights
#
/opt/init/openldap/scripts/root2me.sh /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{0\}config.ldif
/opt/init/openldap/scripts/root2me.sh /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif

# the random user is not allowed to write default locations
cat /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}mdb.ldif | \
       sed s/"^olcDbDirectory: .*"/"olcDbDirectory: \/var\/db"/ | \
       cat > /tmp/mdb.ldif
mv /tmp/mdb.ldif  /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}mdb.ldif

#
# ... start slapd with ldapi for config write access

echo "starting slapd, DEBUGLEVEL=$DEBUGLEVEL"

slapd -4 -h "ldap://$SLAPDHOST:$SLAPDPORT/ ldapi://%2Ftmp%2Fldapi" -d $DEBUGLEVEL
