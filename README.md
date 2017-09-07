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

## Usage

The project provides a couple of custom schemas as exampple. You may select one and run the
related init, load and test scripts.

### Setup
    # start slapd in daemon mode
    dscripts/run.sh -p

    # initialize and test  
    dscripts/exec.sh -i bash /opt/init/openldap/scripts/setupXXXXXX.sh

### Operation

    cd <project root>
    dscripts/run.sh [-p] # start slapd in daemon mode
    dscripts/exec.sh -i  # open a second shell

## User Namespace Mapping

If the docker daemon does not support user namespace maaping, the image will run with the
default ldap uid/gid configured at build time.

## Cluster Configuration

See link:docs/cluster.adoc
