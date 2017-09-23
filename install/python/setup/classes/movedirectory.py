#!/usr/bin/python3

import os
import re
from classes.crc32 import Crc32
from shutil import copyfile


class MoveDirectory(object):

    crc32 = Crc32()

    def __init__(self):
        return

    def change_olc_db_directory(self, path, target):
        lines = list()

        with open(path, "r") as file_in:
            for line in file_in:
                if not line.startswith('#'):
                    replace = 'olcDbDirectory: {}'.format(target)
                    line = re.sub(r'^olcDbDirectory: .*', replace, line)

                    lines.append(line)

        hex_crc = self.crc32.crc_list(lines, 'utf-8')

        file_in.close()

        with open(path, 'w') as file_out:
            file_out.write("# AUTO-GENERATED FILE - DO NOT EDIT!! Use ldapmodify.\n")
            s = "# CRC32 {}\n".format(hex_crc)
            file_out.write(s)
            for line in lines:
                file_out.write(line)

        file_out.close()
