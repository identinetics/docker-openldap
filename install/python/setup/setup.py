#!/usr/bin/python3

import os
from classes.setup import Setup

DB_PATH='/var/db/data.mdb'

PW_PATH = '/etc/conf/passwords'
PW_PATH = 'test_passwords'

if not os.path.isfile(DB_PATH):

    s = Setup(PW_PATH)
    print ("setup")

print ("nosetup")

