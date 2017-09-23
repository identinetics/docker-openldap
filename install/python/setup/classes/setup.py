from packages.passwords import Passwords
from classes.roottome import RootToMe
from classes.movedirectory import MoveDirectory


class Setup(object):
    def __init__(self, pw_path):
        self.pw_path = pw_path
        root2me = RootToMe()
        movedir = MoveDirectory()

        passwords = Passwords(self.pw_path)

        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={0}config.ldif'
        )
        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={1}monitor.ldif'
        )

        movedir.change_olc_db_directory(
            '/etc/openldap/slapd.d/cn=config/olcDatabase={2}mdb.ldif'
        )

        print (passwords)
        return
