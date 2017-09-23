#!/usr/bin/python3

import os
from classes.crc32 import Crc32
from shutil import copyfile


class RootToMe(object):
    PID = os.getuid()
    GID = os.getgid()
    P_PIDNUM = 'uidNumber=0'
    P_GIDNUM = 'gidNumber=0'

    crc32 = Crc32()

    def __init__(self):
        return

    def change_attribute_in_file(self, path):
        lines = list()
        pidnum = 'uidNumber={}'.format(self.PID)
        gidnum = 'gidNumber={}'.format(self.GID)

        with open(path, "r") as file_in:
            for line in file_in:
                if not line.startswith('#'):

                    line = line.replace(self.P_PIDNUM, pidnum)
                    line = line.replace(self.P_GIDNUM, gidnum)

                    lines.append(line)

        hex_crc = self.crc32.crc_list(lines,'utf-8')

        file_in.close()

        with open(path, 'w') as file_out:
            file_out.write("# AUTO-GENERATED FILE - DO NOT EDIT!! Use ldapmodify.\n")
            s = "# CRC32 {}\n".format(hex_crc)
            file_out.write(s)
            for line in lines:
                file_out.write(line)

        file_out.close()

        return


def main():
    r = RootToMe()
    copyfile('config.ori.ldif', 'config.ldif')
    r.change_attribute_in_file('config.ldif')

if __name__ == '__main__':
    main()