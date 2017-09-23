from packages.passwords import Passwords

class Setup(object):

    def __init__(self, pw_path):
        passwords = Passwords(pw_path)

