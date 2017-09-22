#!/usr/bin/python3

import os

from classes.setup import Setup

DB_PATH='/var/db/data.mdb'

if not os.path.isfile(DB_PATH):
    s = Setup()
    print ("setup")

print ("nosetup")

