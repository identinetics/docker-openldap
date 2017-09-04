#!/bin/bash
# convert all schemas in the CWD to ldif files
# schema files have to be named <yourname>.schema
# no dots in yourname allowed

# (c) thomas.warwaris@dress-code.biz
# License: GNU Affero General Public License
# Special thanks to: https://www.lisenet.com/

# the new dn will be <yourname> + this:
ADD_TO_DN=',cn=schema,cn=config'


# first we assemble a convert.conf for all schema files ...

rm -f convert.conf
ls *.schema | while read schemafile ; do
  echo "include $schemafile" >> convert.conf
done

# ... and hand it over to slaptest to generate the .ldifs

mkdir -p c_tmp
slaptest -f ./convert.conf -F c_tmp 2>&1 | grep -v succeeded

# now search through slaptests for results:

ls *.schema | while read schemafile ; do
  entry_name=${schemafile%.*}

  # make sure no old things lying around ...

  newname=${entry_name}.ldif
  if [ -f ${newname} ] ; then
    rm -f ${newname}
  fi

  # ... actually search the result tree of files ...

  find c_tmp -iname "*${entry_name}*.ldif" -exec mv \{\} ${newname}.stage1 \;

  # ... and do a lot of cleaning
  # see: https://www.lisenet.com/2015/convert-openldap-schema-to-ldif/

  sed s/"{[0-9]*}${entry_name}"/"${entry_name}"/g ${newname}.stage1 | \
  sed s/"^\(dn: .*\)"/"\1${ADD_TO_DN}"/g | \
  sed '/structuralObjectClass/,$d' | \
  cat > ${newname}

  rm -f ${newname}.stage1
done

rm -rf c_tmp


# In the special case, that this is run as root, give ownership to the
# user owning the CWD

owner=`stat -c '%U' .`
if [ `whoami` != ${owner} ] ; then
  chown ${owner}:${owner} convert.conf
  chown ${owner}:${owner} *.ldif
fi
