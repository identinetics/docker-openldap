class Passwords(object):
    def __init__(self, path):
        self.passwords = dict()
        with open(path, 'r') as pw:
            for line in pw:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                k, v = (x.strip() for x in line.split('=', 1))
                self.set(k,v)
        return

    def set(self, key, value):
        self.passwords.update({key: value})
        return

    def get(self, key):
        return self.passwords[key]

    def __str__(self):
        pw = list()
        for k, v in self.passwords.items():
            pw.append("{}={}".format(k, v))
        return ",".join(pw)

    def __repr__(self):
        return self.__str__()


def main():
    p = Passwords('passwords.test.txt')
    s = str(p)
    assert s == 'FOO=foopass,BAR=barpass,FOOBAR=foobarpass'
    for x in ['FOO', 'BAR', 'FOOBAR']:
        e = '{}pass'.format(x.lower())
        s = p.get(x)
        assert s == e

if __name__ == '__main__':
    main()