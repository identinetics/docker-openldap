from packages.passwords import Passwords

class Setup(object):
    PW_PATH = '/etc/conf/passwords'

    def __init__(self):
        passwords = Passwords(PW_PATH)
        print (passwords)