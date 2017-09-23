#!/usr/bin/env bash

#
# starting slapd for the new, dynamic configuration
#
#
# .. but first make sure the ldap user has admin rights
#

python3 /opt/init/python/setup.py

#
# ... start slapd with ldapi for config write access

echo "starting slapd, DEBUGLEVEL=$DEBUGLEVEL"

slapd -4 -h "ldap://$SLAPDHOST:$SLAPDPORT/ ldapi://%2Ftmp%2Fldapi" -d $DEBUGLEVEL
