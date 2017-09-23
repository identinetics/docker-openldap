#!/usr/bin/python3

import zlib


class Crc32(object):
    def crc(self,text):
        crc = zlib.crc32(text, 0)
        hex_crc_tst = hex(crc % (1 << 32))
        hex_crc = "{:08x}".format(crc)
        return hex_crc

    def crc_list(self, lines, encoding):
        as_string = "".join(lines).encode(encoding)
        return self.crc(as_string)