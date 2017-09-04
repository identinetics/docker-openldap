ldapadd -Y EXTERNAL -H ldapi:/// -f /opt/init/openldap/ldifs/olcrootpw.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

/opt/init/openldap/scripts/root2me.sh /opt/init/openldap/ldifs/phoat_manager.ldif

ldapmodify -Y EXTERNAL -H ldapi:/// -f /opt/init/openldap/ldifs/phoat_manager.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f  /opt/init/openldap/schemas/phonlineperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /opt/init/openldap/schemas/idnsyncstat.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f /opt/init/openldap/ldifs/twcompare_module.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /opt/init/openldap/ldifs/phoat_twcompare_config.ldif