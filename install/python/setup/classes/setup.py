from packages.passwords import Passwords
from classes.roottome import RootToMe


class Setup(object):
    def __init__(self, pw_path):
        self.pw_path = pw_path
        root2me = RootToMe()

        passwords = Passwords(self.pw_path)

        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn\=config/olcDatabase\=\{0\}config.ldif'
        )
        root2me.change_attribute_in_file(
            '/etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif'
        )
        print (passwords)
        return
