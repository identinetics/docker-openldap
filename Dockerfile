FROM centos:centos7
LABEL maintainer="Rainer Hörbe <r2h2@hoerbe.at>" \
      version="0.0.0" \
      #UID_TYPE: select one of root, non-root or random to announce container behavior wrt USER
      UID_TYPE="random" \
      #didi_dir="https://raw.githubusercontent.com/identinetics/dscripts-test/master/didi" \
      capabilities='--cap-drop=all'

# Enable proxy args if required by docker host
#? ARG http_proxy
#? ARG https_proxy
#? ARG no_proxy

ARG UID=343006
ARG USERNAME=ldap
ENV GID 0
RUN useradd --gid $GID --uid $UID ldap \
 && chown $UID:$GID /run

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl iproute lsof net-tools less \
 && yum -y install python34-devel \
 && curl https://bootstrap.pypa.io/get-pip.py | python3.4 \
 && pip3 install ldap3 \
 && yum clean all

RUN yum -y install "perl(POSIX)" libtool-ltdl systemd-sysv tcp_wrappers-libs

RUN mkdir -p /opt/rpms
COPY openldap-2.4.45/*.rpm /opt/rpms/
RUN yum -y install /opt/rpms/openldap-2.4.*.centos.x86_64.rpm \
 /opt/rpms/openldap-servers-2.4.*.centos.x86_64.rpm \
 /opt/rpms/openldap-clients-2.4.*.centos.x86_64.rpm \
 /opt/rpms/openldap-twcompare-2.4.*.centos.x86_64.rpm \
 && yum clean all

RUN mkdir -p /opt/init/openldap/ldifs
RUN mkdir -p /opt/init/openldap/scripts
RUN mkdir -p /opt/init/openldap/schemas
COPY install/ldifs/* /opt/init/openldap/ldifs/
COPY install/schemas/* /opt/init/openldap/schemas/
COPY install/openldap_scripts/* /opt/init/openldap/scripts/
#RUN chmod +x /opt/init/openldap/scripts/*
#RUN cd /opt/init/openldap/schemas \
# && /opt/init/openldap/scripts/schema2ldif.sh

# save system default ldap config and extend it with project-specific files
RUN mkdir -p /opt/sample_data/etc/openldap/data/
#COPY install/conf/*.conf /etc/openldap/
#COPY install/conf/*hosts /etc/openldap/
#COPY install/conf/schema/*.schema /etc/openldap/schema/
COPY install/data/* /opt/sample_data/etc/openldap/data/
#COPY install/conf/DB_CONFIG /var/db/
COPY install/scripts/* /scripts/
RUN chmod +x /scripts/*
COPY install/tests/* /tests/
RUN chmod +x  /tests/*

#RUN ln -s /etc/conf/slapd.conf /etc/openldap/slapd.conf
RUN mkdir /etc/conf && chmod 777 /etc/conf

ARG SLAPDPORT=8389
ENV SLAPDPORT $SLAPDPORT
# You may want to turn on debugging by setting the following params
# when starting the container:
#ENV DEBUGLEVEL conns,config,stats,shell,trace
ENV DEBUGLEVEL conns,config,stats

# using the shared grop method from https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html (Support Arbitrary User IDs)
# FIXME: We now have mode 777 for the config and db directories due to
# UID-Bug in openshift. This should be closed down to at least set the
# GID to 0 so that we can set this to 770 instead!
RUN mkdir -p /var/log/openldap \
 && chown -R ldap:root /etc/openldap /var/db /var/log/openldap /opt/sample_data /etc/openldap /etc/conf /opt/init/openldap \
 && chmod 664 $(find   /etc/openldap /var/db /var/log/openldap /opt/init/openldap -type f) \
 && chmod 777 $(find   /etc/openldap /var/db /var/log/openldap /opt/init/openldap -type d)

RUN chmod +x /opt/init/openldap/scripts/*

VOLUME /var/db/
# Note: We need the simple file 'slapd.conf' but the /etc/conf directory
# is empty so that OpenShift can safely map the whole directory.
### LFRZ - ConfigMap Volume
VOLUME /etc/conf

EXPOSE 8389

CMD /scripts/start_slapd.sh
USER ldap
