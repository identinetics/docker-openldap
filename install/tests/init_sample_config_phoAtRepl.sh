#!/bin/sh

echo 'initialize slapd.conf with phoAt schema'

# Note: symlink /etc/openldap/slapd.conf -> /etc/conf/slapd.conf
# Due to bug in OpenShift config mapping (which cannot map a single file)
# So we need to generate /etc/conf/slapd.conf

cp /etc/openldap/slapd_phoAtRepl_example.conf /etc/conf/slapd.conf
cp /etc/openldap/slapd_phoAtRepl_slapd_repl.conf /etc/openldap/slapd_repl.conf

if [ $(grep -q '^rootpw' /etc/openldap/slapd.conf) ]; then
    echo "rootpw directive already set in slapd.conf"
else
    slappasswd -s $ROOTPW > /tmp/rootpw
    printf "\nrootpw $(cat /tmp/rootpw)" >> /etc/openldap/slapd.conf
    rm -f /tmp/rootpw
    echo "rootpw directive added to slapd.conf"
fi

