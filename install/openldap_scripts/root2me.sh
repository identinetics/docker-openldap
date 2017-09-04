#!/bin/sh

#
# change root access in an ldif to the calling user
#

cat $1 | \
	sed s/"gidNumber=0+uidNumber=0"/"gidNumber=${GID}+uidNumber=${UID}"/ | \
	cat > /tmp/some_$$.ldif

rm -f $1

mv /tmp/some_$$.ldif $1
