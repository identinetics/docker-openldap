FROM centos:centos7
LABEL maintainer="Rainer Hörbe <r2h2@hoerbe.at>" \
      version="0.0.0" \
      #UID_TYPE: select one of root, non-root or random to announce container behavior wrt USER
      UID_TYPE="random" \
      #didi_dir="https://raw.githubusercontent.com/identinetics/dscripts-test/master/didi" \
      capabilities='--cap-drop=all'

ARG UID=343006
ARG USERNAME=ldap
ENV GID 0
RUN useradd --gid $GID --uid $UID ldap \
 && chown $UID:$GID /run

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl iproute lsof net-tools \
 && yum -y install python34-devel \
 && curl https://bootstrap.pypa.io/get-pip.py | python3.4 \
 && pip3 install ldap3 \
 && yum -y install openldap openldap-servers openldap-clients \
 && yum clean all

# save system default ldap config and extend it with project-specific files
RUN mkdir -p /opt/sample_data/etc/openldap/data/
COPY install/conf/*.conf /etc/openldap/
COPY install/conf/*hosts /etc/openldap/
COPY install/conf/schema/* /etc/openldap/schema/
COPY install/data/* /opt/sample_data/etc/openldap/data/
COPY install/conf/DB_CONFIG /var/db/
COPY install/scripts/* /scripts/
COPY install/tests/* /tests/
RUN chmod +x /scripts/* /tests/*

RUN ln -s /etc/conf/slapd.conf /etc/openldap/slapd.conf

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
 && chown -R ldap:root /etc/openldap /var/db /var/log/openldap /opt/sample_data \
 && chmod 664 $(find   /etc/openldap /var/db /var/log/openldap -type f) \
 && chmod 777 $(find   /etc/openldap /var/db /var/log/openldap -type d)
VOLUME /var/db/
# Note: We need the simple file 'slapd.conf' but the /etc/conf directory
# is empty so that OpenShift can safely map the whole directory.
VOLUME /etc/conf ### LFRZ - ConfigMap Volume

EXPOSE 8389

CMD /scripts/start.sh
USER ldap
