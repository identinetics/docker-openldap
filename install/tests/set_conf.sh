#!/usr/bin/env bash

# get admin credentila from slapd.conf (cleartext pw)
#rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')
#suffix=$(grep ^suffix /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

export ROOTDN='cn=admin,o=BMUKK'
export ROOTPW='changeit'
export BASEDN='o=BMUKK'
export TESTUSERCN='cn=test.user1234567'
export TESTUSERDN="$TESTUSERCN,ou=user,ou=ph08,$BASEDN"
export TESTUSERPW='test'

