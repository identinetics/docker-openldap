from classes.roottome import RootToMe
from classes.movedirectory import MoveDirectory


class PreSetup(object):
    def __init__(self):
        root2me = RootToMe()
        movedir = MoveDirectory()


        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={0}config.ldif'
        )
        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={1}monitor.ldif'
        )

        movedir.change_olc_db_directory(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={2}mdb.ldif', '/var/db'
        )

        return
