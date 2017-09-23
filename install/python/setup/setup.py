#!/usr/bin/python3

import os
from classes.presetup import PreSetup
from classes.setup import Setup

DB_PATH='/var/db/data.mdb'

PW_PATH = '/etc/conf/passwords'
#PW_PATH = 'test_passwords'

if not os.path.isfile(DB_PATH):
    print ("running pre-setup")
    s = PreSetup()
    exit(0)

print ("nosetup")

