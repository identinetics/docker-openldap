# OpenLDAP docker image based on centos7     

The image produces immutable containers, i.e. data volumes are outside the
containers COW file system. A container can be removed and re-created
any time without loss of data, because data is stored on data volumes.

Using the dscripts project this container provides some docker convenience for the CLI.

## Configuration

1. Clone this repository and change into the directory
2. Copy conf.sh.default to conf.sh
3. Run `git submodule update --init` and `cd dscripts && git checkout master && cd ..`
4. Modify conf.sh (optional)
5. dscripts/build.sh  # For local images only

## Updating an older container

Configuration changes are organized in patches. Take a look into the
setupXXXX.sh file, find the patches you want/have to apply and execute
them in the container with dscripts/exec.sh -i.

## Usage

The project provides a couple of custom schemas as exampple. You may select one and run the
related init, load and test scripts.

### Setup
    # start slapd in daemon mode
    dscripts/run.sh -p

    # initialize and test  
    dscripts/exec.sh -i bash /opt/init/openldap/scripts/setupXXXXXX.sh

### Change default passwords
You can change the passwords by using slappasswd and ldapmodify from a container shell. As the container has this Passwords in its environment, you might want to restart your container afterwards with a new configuration.

To get a container shell:
```
dscripts/exec.sh -i bash
```

#### Change the config root password:

1. Generate a new password hash using
```
slappasswd  -h '{CRYPT}' -c '$6$.16s'
```
2. Run ldapmodify and copy the ldif below in its stdin:
```
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi  
dn: olcDatabase={0}config,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: <the hash from slappasswd>
```

#### Change the admin password:
1. Generate a new password hash using
```
slappasswd  -h '{CRYPT}' -c '$6$.16s'
```
2. Run ldapmodify and copy the ldif below in its stdin:
```
ldapmodify -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi  
dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: <the hash from slappasswd>
```

#### Change the bmbreader password:
1. Generate a new password hash using

```
slappasswd  -h '{CRYPT}' -c '$6$.16s'
```

2. Run ldapmodify and copy the ldif below in its stdin:

```
ldapmodify -h $SLAPDHOST -p $SLAPDPORT \
-D "cn=admin,o=BMUKK" -w <your new admin password>   
dn: cn=bmb_reader,ou=readers,o=BMUKK
changetype: modify
replace: userPassword  
userPassword: <the hash from slappasswd>
```

#### Change the monitoring password:
1. Generate a new password hash using
```
slappasswd  -h '{CRYPT}' -c '$6$.16s'
```
2. Run ldapmodify and copy the ldif below in its stdin:
```
ldapmodify -h $SLAPDHOST -p $SLAPDPORT \
-D "cn=admin,o=BMUKK" -w <your new admin password>   
dn: cn=monitoring,ou=readers,o=BMUKK
changetype: modify
replace: userPassword  
userPassword: <the hash from slappasswd>
```


### Operation

    cd <project root>
    dscripts/run.sh [-p] # start slapd in daemon mode
    dscripts/exec.sh -i  # open a second shell

## User Namespace Mapping

If the docker daemon does not support user namespace maaping, the image will run with the
default ldap uid/gid configured at build time.

## Cluster Configuration

See link:docs/cluster.adoc
